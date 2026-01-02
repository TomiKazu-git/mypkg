#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

# colcon ビルド
colcon build > /dev/null 2>&1
source install/setup.bash

# launch を一定時間実行してログを取得
timeout 15 ros2 launch mypkg talk_listen.launch.py > /tmp/mypkg.log 2>&1 || true

# Publish が行われているか
grep -q "Publish" /tmp/mypkg.log

# Listen が行われているか
grep -q "Listen" /tmp/mypkg.log

# ログ表示（Actions確認用）
echo "===== mypkg log ====="
tail -n 20 /tmp/mypkg.log
echo "====================="

exit 0

