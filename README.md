# 最適な肌の治療のために、スキンケアの履歴書

## サービス概要

- 使用しているスキンケアや服用中の薬、アレルギー情報、過去の治療履歴を皮膚科・美容皮膚科での診療のたびに思い出して伝えるのは大変です。
  大切なそれらの情報を整理して「履歴書」としてまとめることができる Web アプリケーションです。
  限られた診療時間で、必要な情報を伝えられるため、より適切な治療を受けるお手伝いをします。

## 技術スタック

- Ruby 3.3.0 Ruby on Rails 8.0.4 Hotwire
- PostgreSQL 16.9

## 環境構築

1. 任意のディレクトリにこのリポジトリのクローンを保存します。

```
git clone https://github.com/sjabcdefin/skincare-resume.git
```

2. リポジトリに移動します。

```
cd skincare-resume
```

3. セットアップを実行します。

```
bin/setup
```

4. Google Cloud で Google ログインに必要な `client_id` と `client_secret` を取得し、`.env` ファイルに設定します。

- `.env`ファイルを作成します。`.env` は環境変数を管理するファイルです（gitには含めません）。

```
touch .env
```

- Google Cloud で取得した `client_id` と` client_secret` を `.env`ファイルに設定します。

```
OMNIAUTH_CLIENT_ID=取得したclient_id
OMNIAUTH_CLIENT_SECRET=取得したclient_secret
```

5. 定期削除処理失敗時のメールアドレスを設定します。

- `.env`ファイルに任意の送信先/送信元メールアドレス(Gmail)を設定します。

```
ALERT_EMAIL_ADDRESS=送信先メールアドレス
MAIL_FROM_ADDRESS=送信元メールアドレス
```

6. アプリを起動します。

```
bin/rails server
```

## テスト

```
bin/rails test:all
```

## Lint

```
bin/lint
```
