#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    return LaunchDescription([
        Node(
            package='mypkg',
            executable='talker',
            output='screen',
            # 配信頻度を1.0Hz（1秒に1回）に設定
            parameters=[{'publish_rate': 1.0}]
        ),
        Node(
            package='mypkg',
            executable='listener',
            output='screen'
        ),
    ])

