#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause


import rclpy
from rclpy.node import Node
from std_msgs.msg import String
from datetime import datetime


class Talker(Node):
    def __init__(self):
        super().__init__("talker")
        self.pub = self.create_publisher(String, "formatted_time", 10)
        self.create_timer(0.5, self.cb)

    def cb(self):
        now = datetime.now()
        msg = String()
        msg.data = now.strftime("%Y-%m-%d %H:%M:%S")
        self.pub.publish(msg)
        self.get_logger().info(f"Publish: {msg.data}")


def main():
    rclpy.init()
    node = Talker()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

