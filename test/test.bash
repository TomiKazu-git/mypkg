#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

# デフォルトディレクトリを設定
DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

# ROS2 パッケージのビルドと環境設定
colcon build > /dev/null 2>&1
source install/setup.bash

# mypkg ディレクトリに移動
cd "$DIR/ros2_ws/src/mypkg/mypkg/"

# listener をバックグラウンドで起動（アンバッファ化）
python3 -u listener.py > /tmp/mypkg_listener.log 2>&1 &
LISTENER_PID=$!

# talker をバックグラウンドで起動（アンバッファ化）
python3 -u talker.py > /tmp/mypkg_talker.log 2>&1 &
TALKER_PID=$!

# 最大 20 秒間、Publish / Listen が 3 回達するまで待機
MAX_WAIT=20
SECONDS=0
while [ $SECONDS -lt $MAX_WAIT ]; do
    PUB_COUNT=$(grep -c "Publish:" /tmp/mypkg_talker.log || true)
    LIS_COUNT=$(grep -c "Listen:" /tmp/mypkg_listener.log || true)

    # 空文字列をゼロに変換
    PUB_COUNT=${PUB_COUNT:-0}
    LIS_COUNT=${LIS_COUNT:-0}

    if [ "$PUB_COUNT" -ge 3 ] && [ "$LIS_COUNT" -ge 3 ]; then
        break
    fi
    sleep 0.5
done

# プロセス終了
kill $LISTENER_PID $TALKER_PID 2>/dev/null || true

# ログが空でないことを確認
[ -s /tmp/mypkg_listener.log ]
[ -s /tmp/mypkg_talker.log ]

# Publish / Listen の回数チェック
PUB_COUNT=${PUB_COUNT:-0}
LIS_COUNT=${LIS_COUNT:-0}

echo "Publish count: $PUB_COUNT"
echo "Listen count: $LIS_COUNT"

if [ "$PUB_COUNT" -lt 3 ] || [ "$LIS_COUNT" -lt 3 ]; then
    echo "Error: Publish/Listen count did not reach 3 within $MAX_WAIT seconds."
    echo "=== talker log ==="
    cat /tmp/mypkg_talker.log
    echo "=== listener log ==="
    cat /tmp/mypkg_listener.log
    exit 1
fi

echo "Test passed: Publish / Listen count >= 3"

