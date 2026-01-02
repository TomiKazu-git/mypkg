#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=${1:-$HOME}
cd "$DIR/ros2_ws"

colcon build > /dev/null 2>&1
source install/setup.bash

# launch をバックグラウンドで起動
timeout 15 ros2 launch mypkg talk_listen.launch.py > /tmp/mypkg.log 2>&1 &
PID=$!

sleep 8

# Publish が出ているか
grep -q "Publish" /tmp/mypkg.log

# Listen が出ているか
grep -q "Listen" /tmp/mypkg.log

# Publish が複数回出ているか
[ "$(grep -c 'Publish' /tmp/mypkg.log)" -ge 2 ]

# Listen が複数回出ているか
[ "$(grep -c 'Listen' /tmp/mypkg.log)" -ge 2 ]

# プロセス終了
kill $PID 2>/dev/null || true
wait $PID 2>/dev/null || true

# ログを表示（Actions確認用）
cat /tmp/mypkg.log

exit 0

