#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e  

source /opt/ros/humble/setup.bash

DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

if [ ! -f install/setup.bash ]; then
    colcon build > /dev/null 2>&1
fi

source install/setup.bash

# listener をバックグラウンドで起動
timeout 10 ros2 run mypkg listener > /tmp/mypkg_listener.log 2>/dev/null &
LISTENER_PID=$!

# talker を起動
sleep 1
timeout 6 ros2 run mypkg talker > /tmp/mypkg_talker.log 2>/dev/null

# listener プロセス終了待機
wait $LISTENER_PID || true

# 正常終了すれば OK とする
echo "Test finished successfully."

exit 0

