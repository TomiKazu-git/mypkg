#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=${1:-$HOME}
cd "$DIR/ros2_ws"

# colcon ビルド
colcon build > /tmp/colcon_build.log 2>&1
source install/setup.bash

# launch をバックグラウンドで起動
cd src/mypkg
timeout 15 ros2 launch mypkg talk_listen.launch.py > /tmp/mypkg_launch.log 2>&1 &
LAUNCH_PID=$!

# 少し待ってノードが生きているか確認
sleep 5
if ! ps -p $LAUNCH_PID > /dev/null; then
    echo "Launch process exited prematurely"
    cat /tmp/mypkg_launch.log
    exit 1
fi

# timeout 経過まで待機
wait $LAUNCH_PID || true

# ログの最後を簡単に表示
echo "--- /tmp/mypkg_launch.log ---"
tail -n 20 /tmp/mypkg_launch.log
echo "----------------------------"

echo "Test finished successfully"

