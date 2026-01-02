#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=${1:-$HOME}
cd "$DIR/ros2_ws"

colcon build > /dev/null
source install/setup.bash

LOG=/tmp/mypkg_test.log
rm -f "$LOG"

# listener を先に起動（十分長め）
timeout 15 ros2 run mypkg listener > "$LOG" 2>&1 &
LISTENER_PID=$!

# ROS 2 の discovery 待ち
sleep 3

# talker を起動（短時間で十分）
timeout 5 ros2 run mypkg talker > /dev/null 2>&1 || true

# listener 終了待ち
wait $LISTENER_PID || true

# 出力確認（1回でも Listen: があれば成功）
grep -q "Listen:" "$LOG"

# YYYY-MM-DD HH:MM:SS 形式っぽいか
grep -Eq "Listen: [0-9]{4}-[0-9]{2}-[0-9]{2}" "$LOG"

