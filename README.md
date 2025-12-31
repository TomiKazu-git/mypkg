# mypkg

2025年度千葉工業大学ロボットシステム学で作成した課題2のリポジトリです。

## 説明
[![test](https://github.com/TomiKazu-git/mypkg/actions/workflows/test.yml/badge.svg)](https://github.com/TomiKazu-git/mypkg/actions/workflows/test.yml)
`mypkg` は、**ROS 2 の時刻を人が読みやすい形式（YYYY-MM-DD HH:MM:SS）に変換して配信する
シンプルな時刻フォーマッタパッケージ**です。

- `talker` ノードが現在時刻を文字列に変換してトピックに publish
- `listener` ノードがその時刻文字列を subscribe して端末に表示
- ROS 2 の **トピック通信（publish / subscribe）** を利用しています

## ノード構成

### talker
- 現在時刻を取得し、`YYYY-MM-DD HH:MM:SS` 形式の文字列に変換
- トピック `formatted_time` に publish（1秒周期）

### listener
- トピック `formatted_time` を subscribe
- 受信した時刻文字列を端末に出力

## 使用方法

### ビルド

```
$ cd ~/ros2_ws
$ colcon build
$ source install/setup.bash
```

### 実行
```
# 端末1
$ ros2 run mypkg listener

# 端末2
$ ros2 run mypkg talker

#実行結果例
[listener] Listen: 2025-12-31 12:00:00
[listener] Listen: 2025-12-31 12:00:01

```

## テスト環境

- GitHub Actions
- Ubuntu 22.04.5 LTS
- Python
  - テスト済みバージョン: 3.7~3.12

## ライセンス

- このソフトウェアパッケージは、３条項BSDライセンスの下、再頒布および使用が許可されています.
- このパッケージのコードは、下記のスライド（CC-BY-SA 4.0 by Ryuichi Ueda）のものを、本人の許可を得て自身の著作としたものです。
  - [ryuichiueda/my_slides robosys_2025](https://github.com/ryuichiueda/slides_marp/tree/master/robosys2025)
- © 2025 Kazuki Mitomi
