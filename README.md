# mypkg

2025年度千葉工業大学ロボットシステム学で作成した課題2のリポジトリです。

## 説明
[![test](https://github.com/TomiKazu-git/mypkg/actions/workflows/test.yml/badge.svg)](https://github.com/TomiKazu-git/mypkg/actions/workflows/test.yml)
`mypkg` は、システムの現在時刻を取得し、「YYYY-MM-DD HH:MM:SS」形式の文字列として配信・表示するROS 2パッケージです。

- **talker ノード**: 
  - 役割: 現在時刻を取得・整形し、1秒周期でメッセージを送信します。
  - 起動方法: ros2 run mypkg talker
- **listener ノード**: 
  - 役割: トピック `formatted_time` から文字列を受信し、標準出力に表示します。
　- 起動方法: ros2 run mypkg listener

## 使用方法

### インストール
ROS 2ワークスペースの `src` ディレクトリにクローンし、ビルドしてください。

```
$ git clone https://github.com/TomiKazu-git/mypkg.git
```

### 実行
各ノードは個別に起動でき、標準的なROS 2ツールとの連携が可能です。

## talker ノードの起動
ターミナルで以下のコマンドを実行し、時刻の配信を開始します。

```
$ ros2 run mypkg talker
```
## 配信内容の確認
別のターミナルで以下のコマンドを実行することで、ノードが正しくデータを配信しているか確認できます。
```
$ ros2 topic echo /formatted_time
# 出力例
# data: "2025-12-31 12:00:00"
```
## listener ノードの起動
さらに別のターミナルで以下のコマンドを実行し、配信された内容を表示します。
```
$ ros2 run mypkg listener
```
## ローンチファイルによる一括起動
上記ノードを同時に起動する場合は、ローンチファイルを使用します。
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
