#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

# ROS 2 本体の環境読み込み
if [ -f /opt/ros/humble/setup.bash ]; then
    source /opt/ros/humble/setup.bash
elif [ -f /opt/ros/foxy/setup.bash ]; then
    source /opt/ros/foxy/setup.bash
fi

DIR=$1
[ "$DIR" = "" ] && DIR=$HOME

cd "$DIR/ros2_ws"

# ビルド
colcon build

# 作成したパッケージの環境読み込み
source install/setup.bash

# talk_listen.launch.py を使って起動し、出力をログへ
timeout 10s ros2 launch mypkg talk_listen.launch.py > /tmp/mypkg.log 2>&1 || true

# ログの確認
if grep -q "Listen: 202" /tmp/mypkg.log; then
    echo "Test Passed"
    exit 0
else
    echo "Test Failed"
    cat /tmp/mypkg.log
    exit 1
fi
