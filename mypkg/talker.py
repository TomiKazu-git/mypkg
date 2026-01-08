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
        
        # パラメータ 'publish_rate' を宣言（デフォルト値 1.0Hz）
        self.declare_parameter('publish_rate', 1.0)
        # 設定された値を取り出す
        rate = self.get_parameter('publish_rate').value
        
        self.publisher = self.create_publisher(String, 'formatted_time', 10)
        
        # 1.0秒を rate で割って周期を決める
        self.timer = self.create_timer(1.0 / rate, self.timer_callback)
        self.count = 0

    def timer_callback(self):
        msg = String()
        now = datetime.now()
        # 人間が読みやすい形式
        formatted_now = now.strftime('%Y-%m-%d %H:%M:%S')
        # コンピュータが処理しやすい形式 (Unix Time)
        unix_time = now.timestamp()
        
        # 両方のデータを組み合わせて送信
        msg.data = f"{formatted_now} (UnixTime: {unix_time})"
        
        self.publisher.publish(msg)
        print(f"Publish: {msg.data}", flush=True)
        self.count += 1
        
        # 3回送ったら停止
        if self.count >= 3:

            self.get_logger().info("Finished publishing 3 messages. Shutting down...")
            rclpy.shutdown()

def main():
    rclpy.init()
    node = Talker()
    try:
        rclpy.spin(node)
    except (KeyboardInterrupt, rclpy.executors.ExternalShutdownException):
        pass
    finally:

        if rclpy.ok():
            node.destroy_node()
            rclpy.shutdown()

if __name__ == '__main__':
    main()

