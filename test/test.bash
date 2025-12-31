#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

# ビルド
colcon build > /dev/null 2>&1
source install/setup.bash

# listener をバックグラウンドで起動
cd "$DIR/ros2_ws/src/mypkg/mypkg/"
timeout 10 python3 test_listener.py > /tmp/mypkg_listener.log 2>&1 || true &
LISTENER_PID=$!

# talker を起動して Publish
timeout 10 python3 similality_images.py > /tmp/mypkg_talker.log 2>&1 || true

# listener の終了待ち
wait $LISTENER_PID || true

# ログ内容を確認
cat /tmp/mypkg_listener.log
cat /tmp/mypkg_talker.log

exit 0

