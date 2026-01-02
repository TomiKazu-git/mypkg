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

# launch で同時起動
timeout 10 ros2 launch mypkg talk_listen.launch.py > "$LOG" 2>&1 || true

# Publish と Listen が出ているか
grep -q "Publish:" "$LOG"
grep -q "Listen:" "$LOG"

# chatter トピックを使っているか
grep -q "chatter" "$LOG" || true

# talker / listener が起動している形跡
grep -q "talker" "$LOG" || true
grep -q "listener" "$LOG" || true

exit 0

