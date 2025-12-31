#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String


class Listener(Node):
    def __init__(self):
        super().__init__("listener")
        self.create_subscription(
            String,
            "formatted_time",
            self.cb,
            10
        )

    def cb(self, msg):
    self.get_logger().info(f"Listen: {msg.data}")
    with open("/tmp/mypkg_listener.log", "a") as f:
        f.write(f"Listen: {msg.data}\n")


def main():
    rclpy.init()
    node = Listener()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

