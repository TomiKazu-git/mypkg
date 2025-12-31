#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():

    talker = Node(
        package='mypkg',
        executable='talker',
        name='time_publisher',
        output='screen'
    )

    listener = Node(
        package='mypkg',
        executable='listener',
        name='time_listener',
        output='screen'
    )

    return LaunchDescription([talker, listener])

