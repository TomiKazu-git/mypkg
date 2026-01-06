# mypkg

2025年度千葉工業大学ロボットシステム学で作成した課題2のリポジトリです。

## 説明
[![test](https://github.com/TomiKazu-git/mypkg/actions/workflows/test.yml/badge.svg)](https://github.com/TomiKazu-git/mypkg/actions/workflows/test.yml)
`mypkg` は、システムの現在時刻を取得し、「YYYY-MM-DD HH:MM:SS」形式の文字列として配信・表示するROS 2パッケージです。

- **talker (実行コマンド: `talker`)**: 
  - 役割: 現在時刻を取得・整形し、1秒周期でパブリッシュします。
  - 送信トピック名: `formatted_time`
  - メッセージ型: `std_msgs/String`
- **listener (実行コマンド: `listener`)**: 
  - 役割: トピック `formatted_time` を購読し、受信した文字列を標準出力に表示します。

## 使用方法

### ビルド

```
$ cd ~/ros2_ws/src
$ git clone https://github.com/TomiKazu-git/mypkg.git
$ cd ~/ros2_ws
$ colcon build
$ source install/setup.bash
```

### 実行
ローンチファイルを使用して、パブリッシャー（talker）とリスナー（listener）の両方を同時に起動します。

```
$ ros2 launch mypkg talk_listen.launch.py

#実行結果例
[listener-2] Listen: 2025-12-31 12:00:00
[listener-2] Listen: 2025-12-31 12:00:01
...
```

## テスト環境

- **GitHub Actions (CI)**
  - **OS**: Ubuntu 22.04.5 LTS (GitHub Actions Runner: `ubuntu-22.04`)
  - **ROS 2**: Humble
- **Python**
  - バージョン: 3.10.x

## ライセンス

- このソフトウェアパッケージは、３条項BSDライセンスの下、再頒布および使用が許可されています.
- このパッケージのコードは、下記のスライド（CC-BY-SA 4.0 by Ryuichi Ueda）のものを、本人の許可を得て自身の著作としたものです。
  - [ryuichiueda/my_slides robosys_2025](https://github.com/ryuichiueda/slides_marp/tree/master/robosys2025)
- © 2025 Kazuki Mitomi
