#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=${1:-$HOME}

cd "$DIR/ros2_ws"

# ビルド
colcon build > /dev/null 2>&1
source install/setup.bash

LOG=/tmp/mypkg_test.log
rm -f "$LOG"

# launch で talker / listener 同時起動
timeout 15 ros2 launch mypkg talk_listen.launch.py > "$LOG" 2>&1 || true

# ログに Publish / Listen があるか確認
grep -q "Publish:" "$LOG"
grep -q "Listen:" "$LOG"

exit 0

