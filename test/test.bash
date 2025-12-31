#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

# ビルド（標準出力・標準エラーを抑制）
colcon build > /dev/null 2>&1
source install/setup.bash

# listener をバックグラウンドで起動
cd "$DIR/ros2_ws/src/mypkg/mypkg/"
timeout 10 python3 test_listener.py > /tmp/mypkg_listener.log 2>&1 &

# talker を起動して Publish
timeout 10 python3 similality_images.py > /tmp/mypkg_talker.log 2>&1

# listener の終了待ち
wait

# ログを確認して標準出力に出す
cat /tmp/mypkg_listener.log
cat /tmp/mypkg_talker.log

exit 0

