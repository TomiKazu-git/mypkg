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

# 少し待ってからログ確認
sleep 10

# Publish / Listen が出ているか簡単に確認
grep -q "Publish" /tmp/mypkg_launch.log || { echo "No Publish detected"; exit 1; }
grep -q "Listen" /tmp/mypkg_launch.log || { echo "No Listen detected"; exit 1; }

# プロセス終了
kill $LAUNCH_PID || true
wait $LAUNCH_PID || true

# ログの簡単表示
echo "--- /tmp/mypkg_launch.log ---"
tail -n 20 /tmp/mypkg_launch.log
echo "----------------------------"

echo "Test finished successfully"

