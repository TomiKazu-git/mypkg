#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=~
[ "$1" != "" ] && DIR="$1"

cd $DIR/ros2_ws

colcon build
source install/setup.bash

timeout 10 ros2 run mypkg listener > /tmp/mypkg_listener.log &
LISTENER_PID=$!

sleep 1

timeout 6 ros2 run mypkg talker > /tmp/mypkg_talker.log

wait $LISTENER_PID || true

grep "Publish:" /tmp/mypkg_talker.log
grep "Listen:" /tmp/mypkg_listener.log

grep -E "Listen: [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}" /tmp/mypkg_listener.log

PUB_COUNT=$(grep -c "Publish:" /tmp/mypkg_talker.log)
LIS_COUNT=$(grep -c "Listen:" /tmp/mypkg_listener.log)

[ "$PUB_COUNT" -ge 3 ]
[ "$LIS_COUNT" -ge 3 ]

exit 0


