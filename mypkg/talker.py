#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import Int16


class Talker(Node):
    def __init__(self):
        super().__init__("talker")
        self.publisher = self.create_publisher(Int16, "countup", 10)
        self.n = 0
        self.create_timer(0.5, self.timer_callback)

    def timer_callback(self):
        msg = Int16()
        msg.data = self.n
        self.publisher.publish(msg)
        self.get_logger().info(f"Publish: {self.n}")
        self.n += 1


def main():
    rclpy.init()
    node = Talker()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

