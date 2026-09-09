# メモアプリ

## 必要なもの
 * Ruby
 * PostgreSQL

## セットアップ
### 1. リポジトリを取得
以下のコマンドを実行してリポジトリを取得します。
```
$ git clone https://github.com/sayaTT38/sinatra-practices.git
```

### 2. Gemをインストール
取得したリポジトリへ移動し、必要なGemをインストールします。
```
$ cd sinatra-practices
$ bundle install
```

### 3. PostgreSQLにDBを作成
アプリ用のDBとして`memo_app`を作成します。
```
$ psql -U postgres -f create_database.sql
```
以下のコマンドでDBが作成できていることを確認します。
```
postgres=# \l
```
`memo_app`が一覧に表示されていればDBの作成は完了です。

以下のコマンドでPostgreSQLとの接続を切断します。
```
postgres=# \q
```
### 4. テーブルを作成
以下のコマンドを打って`memos`テーブルを作成します。
```
$ psql -U postgres -d memo_app -f create_table.sql
```
以下のコマンドでテーブルが作成できていることを確認します。
```
$ psql -U postgres -d memo_app
```
```
memo_app=# \dt
```
```
memo_app=# \d memos
```
`memos`が表示されていればテーブルの作成は完了です。

以下のコマンドでPostgreSQLとの接続を切断します。
```
memo_app=# \q
```
### 5. DBのパスワードを設定
アプリからPostgreSQLへ接続するため、環境変数 `DB_PASSWORD` にPostgreSQLのパスワードを設定します。
```
$ export DB_PASSWORD='PostgreSQLのパスワード'
```

### 6. アプリを起動
アプリを起動します。
```
$ bundle exec ruby lib/memo_app.rb
```

起動後、ブラウザで以下へアクセスしてください。

http://localhost:4567

## 使用技術
 * Ruby
 * Sinatra
 * PostgreSQL
