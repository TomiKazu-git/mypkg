#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"
colcon build
source install/setup.bash

# ログファイルの準備
touch /tmp/mypkg_listener.log
chmod 666 /tmp/mypkg_listener.log

# listener をバックグラウンドで起動
timeout 10 python3 "$DIR/ros2_ws/src/mypkg/mypkg/listener.py" > /tmp/mypkg_listener.log 2>&1 &
LISTENER_PID=$!

# talker を起動 
timeout 10 python3 "$DIR/ros2_ws/src/mypkg/mypkg/talker.py" > /tmp/mypkg_talker.log 2>&1 || true

# listener の終了待ち
wait $LISTENER_PID || true

# ログ内容を確認
cat /tmp/mypkg_listener.log
