#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

colcon build > /dev/null 2>&1
source install/setup.bash

cd "$DIR/ros2_ws/src/mypkg/mypkg/"

# listener をバックグラウンドで 10 秒タイムアウトで起動
timeout 10 python3 listener.py > /tmp/mypkg_listener.log 2>&1 || true &
LISTENER_PID=$!

# talker を起動して Publish
timeout 10 python3 talker.py > /tmp/mypkg_talker.log 2>&1 || true

# listener の終了待ち
wait $LISTENER_PID || true

# ログ内容を確認
cat /tmp/mypkg_listener.log
cat /tmp/mypkg_talker.log

# ログが生成されているか確認
[ -s /tmp/mypkg_listener.log ] || { echo "Listener log is empty"; exit 1; }
[ -s /tmp/mypkg_talker.log ] || { echo "Talker log is empty"; exit 1; }

# ログに Publish / Listen の文字列があるか確認
grep -q "Publish" /tmp/mypkg_talker.log || { echo "No Publish detected"; exit 1; }
grep -q "Listen" /tmp/mypkg_listener.log || { echo "No Listen detected"; exit 1; }

echo "Simple test passed."

exit 0

