#!/bin/bash
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

set -e

# ROS2 環境
source /opt/ros/humble/setup.bash

# デフォルトはホームディレクトリ
DIR=$HOME
[ "$1" != "" ] && DIR="$1"

cd "$DIR/ros2_ws"

# ビルドと環境設定
colcon build > /dev/null 2>&1
source install/setup.bash

# listener をバックグラウンド起動
timeout 10 ros2 run mypkg listener > /tmp/mypkg_listener.log 2>/dev/null &
LISTENER_PID=$!

# talker を起動
sleep 1
timeout 6 ros2 run mypkg talker > /tmp/mypkg_talker.log 2>/dev/null

# listener 終了待機
wait $LISTENER_PID || true

# ==== しつこくテスト ====

# publish / listen 回数チェック
PUB_COUNT=$(grep -c "Publish:" /tmp/mypkg_talker.log || true)
LIS_COUNT=$(grep -c "Listen:" /tmp/mypkg_listener.log || true)
[ "$PUB_COUNT" -ge 3 ]
[ "$LIS_COUNT" -ge 3 ]

# タイムスタンプ形式
grep -E "Listen: [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}" /tmp/mypkg_listener.log > /dev/null

# 最新 Publish が listener に届いているか
LAST_PUB=$(tail -n1 /tmp/mypkg_talker.log | awk '{print $2}')
LAST_LISTEN=$(tail -n1 /tmp/mypkg_listener.log | awk '{print $2}')
[ "$LAST_PUB" = "$LAST_LISTEN" ]

# タイマー周期チェック
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

# ログが空でないか
[ -s /tmp/mypkg_talker.log ]
[ -s /tmp/mypkg_listener.log ]

exit 0

