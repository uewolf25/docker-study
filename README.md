# Docker ハンズオン用

## 1. MySQLのコンテナを作ってログインしてみる。(step1)
途中でわからなくなったり、作業結果が知りたい人向けに[ログ](https://github.com/uewolf25/docker-study/issues/1)残してるので参照どうぞ。

### DockerHubからイメージ`MySQL5.7`をpullする。
```
docker pull mysql:5.7
          ↑↑↑
(docker pull '欲しいイメージ':'version指定')
```

### pullできたかの確認。(手元のイメージを確認する)
```
docker images
```

## コンテナ編
### イメージを元にコンテナ立てるよん☆ 起動！！！！立ちあがっれ〜(ry
```
docker run --name mysql_login_only -e MYSQL_ROOT_PASSWORD=pass -d -p 3000:3000 mysql:5.7
```
深掘り↓
```
--name: コンテナの名前をつける
-e: 環境変数
-d(--detach): コンテナをバックグラウンドで実行する。要終了。
-p: portforwarding
```

### 立ち上がってるコンテナの確認
```
docker ps
```
上の通りにすると、NAMEが`mysql_login_only`になっているはず。
ちなみに,
```
docker ps -a
```
で今は立ってないが、昔立ち上げたことのあるコンテナの一覧を出せる。

### コンテナに接続しよう^^
```
docker exec -it 'コンテナID(初めの3桁ぐらいだけでいいよ)' bash
```
オプションの説明
```
-i: 標準入力を開き続ける
-t: 擬似ttyを割り当てる
→つまり、標準入力を受付け、そこを操作可能にする。

コンテナに接続すると、
root@xxxxxxx:/# 
プロンプトが変わるはず。
```

### コンテナ内からMySQLを起動してみるよ！
必要最低限のものはコンテナの中に用意されているので、ログインしてみる。
```
mysql -u root -p
Enter password: runした時、'-e MYSQL_ROOT_PASSWORD='の環境変数をここにドォーん！
```
ログインできたらプロンプトは`mysql>`になったかな？

## MySQL編
### どんなデータベースがある？
```
show databases;
```

### 実際にデータベースを作ってみる。
```
create database test;
```
OK!って表示されるはず。

### データベースを選択する。
```
use test;
```
Database changedって表示されたかな〜？

### テーブルの表示
```
show tables;
```
何も登録していないので無い。

### テーブル作ろう
```
create table test_table(
 id int(10) auto_increment not null,
 name varchar(32) not null,
 primary key (id)
);
```

### 再度テーブルの確認
```
show tables;
```
test_tableが表示されてるカナ？✋

### データベース編で何をしたか。。。？わっかぁんないよぉ。。。。ﾋﾟｴﾝ
`test`っていうデータベースを作りました。  
そのデータベースの中で`test_table`っていうテーブルを作りました。  
レコードは`id`, `name`。

## レコードの操作編
実際に軽くレコードを追加・削除してみよう。

### データの追加
```
insert into test_table (name) values ("hoge");
```
```
insert into test_table (name) values ("hoge");
```
２つぐらい入れとこ。
`id`はauto_incrementで自動的に加算されていくので、書く必要はない。

### データの確認
```
select * from test_table;
```
全部表示しろというコマンド。


### データの削除
```
delete from test_table where id=1;
```
whereの後に条件を入れることで、任意の操作を行うことができる。
今回は'idが１'の人のデータを削除する。

### データの確認(２回目)
```
select * from test_table;
```
id=2しか残ってないよね？

## コンテナから離脱
### mysqlからログアウト
```
exit
quit
ctrl+D
```
上記いずれかで抜けれる。


### コンテナからも抜ける
```
exit
ctrl+D
```

## 使用したコンテナの終了の仕方
### 稼働中のコンテナの確認
```
docker ps
```

### コンテナを終了する
```
docker stop 'コンテナID'
```

## step1の補足
データベースの詳しい説明は次(22:00~)のサーバ周りの勉強会で話します。

上にも書いてますが、私の作業結果をみてみたい人向けにログ取ってます。   
[こちら参照(issue#1へ飛びます)。](https://github.com/uewolf25/docker-study/issues/1)

___

## 2. コンテナを一度消してデータベースの情報が消えていることの確認(step2)
コンテナをstopしていないと消すことができないので注意。
### 稼働していないコンテナの確認
```
docker ps -a
```

### コンテナの削除
```
docker rm コンテナID
```

### 再び確認
```
docker ps -a
```
MySQLに関してのコンテナはないはず。

### 再度mysql:5.7を使用し、コンテナを起動させる。→MySQLへログイン。
```
docker run --name mysql_login_only -e MYSQL_ROOT_PASSWORD=pass -d -p 3000:3000 mysql:5.7
docker ps

docker exec -it コンテナID bash
mysql -u root -p pass
Enter password: 'パスを入力'
```

### データベースの情報の確認
```
show databases;
```
OMG...
頑張って作ったデータベース消えとる。。。

### step2の補足
はい、消えていることが確認できました。

step2もログ残しているので、見たい方は[こちらにアクセス](https://github.com/uewolf25/docker-study/issues/2)してどうぞ。
___

## 3. docker-composeで起動する。かつ、永続化を図る。(step3)

### たった１つのコマンドで起動できちゃう♡
```
docker-compose up -d
```
`-d`はバックグラウンドで実行する。

### データの挿入
```
docker exec -it 'コンテナID' bash

mysql -u root -p

show databases;
use test;
show tables;
INSERT INTO test_table (name) VALUES ("hoge");
INSERT INTO test_table (name) VALUES ("fuuuuuuuuu");
select * from test_table;
```
永続化確認のため、ctrl+Dでmysql, コンテナから出る。
```
docker-compose down
```
これでコンテナ終了。

### 永続化ができているかの確認
もう一度コンテナ、mysqlに入ってデータが入っていれば永続化が確認できたことになる。
```
docker-compose up -d
docker exec -it 'コンテナID' bash

mysql -u root -p

show databases;
use test;
show tables;

select * from test_table;
```
データは入ってましたか？

```
mysql> select * from test_table;
+----+------------+
| id | name       |
+----+------------+
|  1 | hoge       |
|  2 | fuuuuuuuuu |
+----+------------+
2 rows in set (0.01 sec)
```
上記のようになっていれば成功。

### step3の補足

step3もログ残しているので、見たい方は[こちらにアクセス](https://github.com/uewolf25/docker-study/issues/3)してどうぞ






