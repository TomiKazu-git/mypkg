#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

# ビルドと環境設定
colcon build > /dev/null 2>&1
source install/setup.bash

cd "$DIR/ros2_ws/src/mypkg/mypkg/"

# listener をバックグラウンドで起動
python3 listener.py > /tmp/mypkg_listener.log 2>&1 &
LISTENER_PID=$!

# talker をバックグラウンドで起動
python3 talker.py > /tmp/mypkg_talker.log 2>&1 &
TALKER_PID=$!

# 10秒以内に Publish/Listen が 3 回確認できるまで待機
SECONDS=0
while [ $SECONDS -lt 10 ]; do
    PUB_COUNT=$(grep -c "Publish:" /tmp/mypkg_talker.log || true)
    LIS_COUNT=$(grep -c "Listen:" /tmp/mypkg_listener.log || true)
    if [ "$PUB_COUNT" -ge 3 ] && [ "$LIS_COUNT" -ge 3 ]; then
        break
    fi
    sleep 0.5
done

# プロセス終了
kill $LISTENER_PID $TALKER_PID 2>/dev/null || true

# ログが空でないこと
[ -s /tmp/mypkg_listener.log ]
[ -s /tmp/mypkg_talker.log ]

# Publish / Listen の回数チェック
[ "$PUB_COUNT" -ge 3 ]
[ "$LIS_COUNT" -ge 3 ]

# ログ確認
cat /tmp/mypkg_listener.log
cat /tmp/mypkg_talker.log

exit 0

