#!/usr/bin/env python3
# SPDX-FileCopyrightText: 2025 Kazuki Mitomi
# SPDX-License-Identifier: BSD-3-Clause

import rclpy
from rclpy.node import Node
from std_msgs.msg import String
from datetime import datetime

class Talker(Node):
    def __init__(self):
        super().__init__('talker')
        self.publisher = self.create_publisher(String, 'formatted_time', 10)
        self.timer = self.create_timer(1.0, self.timer_callback)
        self.count = 0

    def timer_callback(self):
        msg = String()
        now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        msg.data = f"{now}"
        self.publisher.publish(msg)
        print(f"Publish: {msg.data}", flush=True)
        self.count += 1
        # 3回送ったら停止
        if self.count >= 3:
            rclpy.shutdown()

def main():
    rclpy.init()
    node = Talker()
    try:
        rclpy.spin(node)
    except (KeyboardInterrupt, rclpy.executors.ExternalShutdownException):
        pass
    finally:
        node.destroy_node()

if __name__ == '__main__':
    main()

