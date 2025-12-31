#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e  # エラーが出たら即失敗

DIR=~
[ "$1" != "" ] && DIR="$1"

echo "[TEST] Build package"
cd $DIR/ros2_ws
colcon build

echo "[TEST] Source setup"
source install/setup.bash

echo "[TEST] Run listener and talker"

# listener をバックグラウンドで起動
timeout 10 ros2 run mypkg listener > /tmp/mypkg_listener.log &
LISTENER_PID=$!

# 少し待ってから talker 起動
sleep 1
timeout 5 ros2 run mypkg talker > /tmp/mypkg_talker.log

# listener 終了待ち
wait $LISTENER_PID || true

echo "[TEST] Check output"

# Publish が行われている
grep "Publish:" /tmp/mypkg_talker.log

# Listen が行われている
grep "Listen:" /tmp/mypkg_listener.log

# 時刻フォーマット確認（YYYY-MM-DD HH:MM:SS）
grep -E "Listen: [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}" /tmp/mypkg_listener.log

echo "[TEST] All tests passed"

