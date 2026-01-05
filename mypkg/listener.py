#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String


class Listener(Node):
    def __init__(self):
        super().__init__('listener')
        self.subscription = self.create_subscription(
            String,
            'chatter',
            self.callback,
            10
        )
        self.count = 0

    def callback(self, msg):
        print(f"Listen: {msg.data}", flush=True)
        self.count += 1
        if self.count >= 3:
            rclpy.shutdown()


def main():
    rclpy.init()
    node = Listener()
    rclpy.spin(node)
    node.destroy_node()


if __name__ == '__main__':
    main()

