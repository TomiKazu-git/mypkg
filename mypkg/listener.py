#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from std_msgs.msg import String
from rclpy.node import Node

class Listener(Node):
    def __init__(self):
        super().__init__('listener')
        self.subscription = self.create_subscription(
            String,
            'chatter',
            self.listener_callback,
            10)
        self.subscription  # prevent unused variable warning
        self.count = 0

    def listener_callback(self, msg):
        print(f"Listen: {msg.data}", flush=True)
        self.count += 1
        if self.count >= 5:
            rclpy.shutdown()

def main():
    rclpy.init()
    node = Listener()
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()

if __name__ == "__main__":
    main()

