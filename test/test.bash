#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

DIR=~
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

colcon build > /dev/null 2>&1
source install/setup.bash

timeout 10 ros2 run mypkg listener > /tmp/mypkg_listener.log 2>/dev/null &
LISTENER_PID=$!

sleep 1
timeout 6 ros2 run mypkg talker > /tmp/mypkg_talker.log 2>/dev/null

wait $LISTENER_PID || true

PUB_COUNT=$(grep -c "Publish:" /tmp/mypkg_talker.log)
LIS_COUNT=$(grep -c "Listen:" /tmp/mypkg_listener.log)

[ "$PUB_COUNT" -ge 3 ]
[ "$LIS_COUNT" -ge 3 ]

grep -E "Listen: [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}" /tmp/mypkg_listener.log > /dev/null

# 最新の Publish を Listen が受け取っているか
LAST_PUB=$(tail -n1 /tmp/mypkg_talker.log | awk '{print $2}')
LAST_LISTEN=$(tail -n1 /tmp/mypkg_listener.log | awk '{print $2}')
[ "$LAST_PUB" = "$LAST_LISTEN" ]

# タイマー周期（1秒程度）簡易チェック
PREV=""
while read -r line; do
  TIME=$(echo "$line" | awk '{print $2}')
  if [ -n "$PREV" ]; then
    PREV_SEC=$(date -d "$PREV" +%s)
    CUR_SEC=$(date -d "$TIME" +%s)
    DIFF=$((CUR_SEC - PREV_SEC))
    [ "$DIFF" -ge 0 ] && [ "$DIFF" -le 2 ]
  fi
  PREV="$TIME"
done < <(grep "Listen:" /tmp/mypkg_listener.log)

exit 0

