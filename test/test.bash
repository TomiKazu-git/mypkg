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

# launch で同時起動（バックグラウンド）
timeout 15 ros2 launch mypkg talk_listen.launch.py > "$LOG" 2>&1 &
PID=$!

# 最大10秒、Publish/Listenが出るまで待つ
for i in {1..10}; do
    if grep -q "Publish:" "$LOG" && grep -q "Listen:" "$LOG"; then
        echo "OK: Publish and Listen detected"
        break
    fi
    sleep 1
done

# 最終チェック
grep -q "Publish:" "$LOG"
grep -q "Listen:" "$LOG"

wait $PID || true

