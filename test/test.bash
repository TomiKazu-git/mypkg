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
timeout 10 python3 listener.py > /tmp/mypkg_listener.log 2>&1 || true &
LISTENER_PID=$!

# talker を起動
python3 talker.py > /tmp/mypkg_talker.log 2>&1 || true

# listener の終了待ち
wait $LISTENER_PID || true

# ログが空でないこと
[ -s /tmp/mypkg_listener.log ]
[ -s /tmp/mypkg_talker.log ]

# Publish / Listen の回数チェック
PUB_COUNT=$(grep -c "Publish:" /tmp/mypkg_talker.log || true)
LIS_COUNT=$(grep -c "Listen:" /tmp/mypkg_listener.log || true)
[ "$PUB_COUNT" -ge 3 ]
[ "$LIS_COUNT" -ge 3 ]

# ログ確認
cat /tmp/mypkg_listener.log
cat /tmp/mypkg_talker.log

exit 0

