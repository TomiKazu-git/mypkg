#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String


class Talker(Node):
    def __init__(self):
        super().__init__('talker')
        self.publisher = self.create_publisher(String, 'chatter', 10)
        self.timer = self.create_timer(1.0, self.timer_callback)
        self.count = 0

    def timer_callback(self):
        msg = String()
        msg.data = f"Hello {self.count}"
        self.publisher.publish(msg)
        print(f"Publish: {msg.data}", flush=True)
        self.count += 1
        if self.count >= 3:
            rclpy.shutdown()


def main():
    rclpy.init()
    node = Talker()
    rclpy.spin(node)
    node.destroy_node()


if __name__ == '__main__':
    main()


