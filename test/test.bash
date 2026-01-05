#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=$1
[ "$DIR" = "" ] && DIR=$HOME

cd "$DIR/ros2_ws"
colcon build
source install/setup.bash

# talk_listen.launch.py を使って起動し、出力をログへ
# 10秒経ったら自動で終了させる
timeout 10s ros2 launch mypkg talk_listen.launch.py > /tmp/mypkg.log 2>&1 || true

if grep -q "Listen: 202" /tmp/mypkg.log; then
    echo "Test Passed"
    exit 0
else
    echo "Test Failed"
    cat /tmp/mypkg.log
    exit 1
fi
