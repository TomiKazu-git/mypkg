#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
from datetime import datetime


class TimePublisher(Node):
    def __init__(self):
        super().__init__("talker")
        self.publisher = self.create_publisher(String, "formatted_time", 10)
        self.create_timer(1.0, self.timer_callback)

    def timer_callback(self):
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    msg = String()
    msg.data = now
    self.publisher.publish(msg)
    self.get_logger().info(f"Publish: {now}")
    with open("/tmp/mypkg_talker.log", "a") as f:
        f.write(f"Publish: {now}\n")


def main():
    rclpy.init()
    node = TimePublisher()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()


