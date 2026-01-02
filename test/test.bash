#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=${1:-$HOME}
cd "$DIR/ros2_ws"

# build
colcon build > /dev/null 2>&1
source install/setup.bash

LOG=/tmp/mypkg_test.log
rm -f "$LOG"

# listener を先に起動
timeout 10 ros2 run mypkg listener > "$LOG" 2>&1 &
LISTENER_PID=$!

# 少し待つ
sleep 1

# talker を起動
timeout 5 ros2 run mypkg talker > /dev/null 2>&1 || true

# listener 終了待ち
wait $LISTENER_PID || true


# Listen が出ているか
grep -q "Listen:" "$LOG"

# Publish に対応した文字列が受信されているか
grep -q "Hello" "$LOG"

# 複数回受信しているか
COUNT=$(grep -c "Listen:" "$LOG")
[ "$COUNT" -ge 2 ]

exit 0

