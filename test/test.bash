#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=${1:-$HOME}
cd "$DIR/ros2_ws"

colcon build > /dev/null 2>&1
source install/setup.bash

LOG=/tmp/mypkg_test.log
rm -f "$LOG"

timeout 20 ros2 run mypkg listener > "$LOG" 2>&1 &
LISTENER_PID=$!

sleep 2
timeout 5 ros2 run mypkg talker > /dev/null 2>&1 || true
wait $LISTENER_PID || true

# 1. Listen が1回以上
grep -q "Listen:" "$LOG"

# 2. 複数回出ている（厳密な回数は見ない）
COUNT=$(grep -c "Listen:" "$LOG")
[ "$COUNT" -ge 2 ]

# 3. 日付形式らしきものが含まれる
grep -E -q "[0-9]{4}-[0-9]{2}-[0-9]{2}" "$LOG"

