# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    # PostgreSQL の `uuid` を使用するための拡張機能を有効化
    enable_extension 'pgcrypto'
    # `id: :uuid` を指定して `uuid` をプライマリーキーに設定
    create_table :users, id: :uuid  do |t|
      ## Database authenticatable（認証情報の保存）
      # ユーザーのメールアドレス（必須、デフォルトは空文字）
      t.string :email, null: false, default: ''
      # 暗号化されたパスワード（必須、デフォルトは空文字）
      t.string :encrypted_password, null: false, default: ''

      # deviseでユーザーログインできるようにカラムを追加
      t.string :name, null: false

      ## Recoverable（パスワードリセット機能）
      # パスワードリセット用のトークン（ワンタイムキー）
      t.string   :reset_password_token
      # パスワードリセットメールを送信した日時
      t.datetime :reset_password_sent_at

      ## Rememberable（ログイン情報の保持）
      # 「ログイン状態を保持する」機能のためのタイムスタンプ
      t.datetime :remember_created_at

      ## Trackable（ログイン履歴の記録）
      # 以下のカラムはデフォルトでは無効（コメントアウトされている）
      # 必要に応じてコメントを外して有効化できる

      # ログイン回数
      # t.integer  :sign_in_count, default: 0, null: false
      # 最新のログイン日時
      # t.datetime :current_sign_in_at
      # 直前のログイン日時
      # t.datetime :last_sign_in_at
      # 最新のログインIPアドレス
      # t.string   :current_sign_in_ip
      # 直前のログインIPアドレス
      # t.string   :last_sign_in_ip

      ## Confirmable（メールアドレス確認機能）
      # 以下のカラムはデフォルトでは無効（コメントアウトされている）
      # メール確認を必須にする場合はコメントを外して有効化できる

      # メールアドレス確認用のトークン
      # t.string   :confirmation_token
      # 確認が完了した日時
      # t.datetime :confirmed_at
      # 確認メールが送信された日時
      # t.datetime :confirmation_sent_at
      # メールアドレス変更時に新しいアドレスを一時保存
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable（アカウントロック機能）
      # 以下のカラムはデフォルトでは無効（コメントアウトされている）
      # アカウントロック機能を有効にする場合はコメントを外す

      # ログイン失敗回数（一定回数失敗するとロック）
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # アカウントロック解除用のトークン
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # アカウントがロックされた日時
      # t.datetime :locked_at

      ## 共通のタイムスタンプ
      # `created_at` → ユーザーの登録日時
      # `updated_at` → ユーザー情報の最終更新日時
      t.timestamps null: false
    end

    ## インデックスの追加
    # メールアドレスに一意制約（同じメールアドレスを持つユーザーは登録できない）
    add_index :users, :email, unique: true
    # パスワードリセットトークンに一意制約（ワンタイムキーのため）
    add_index :users, :reset_password_token, unique: true
    # メール確認トークンに一意制約（メール確認を有効化する場合に必要）
    # add_index :users, :confirmation_token,   unique: true
    # アカウントロック解除トークンに一意制約（ロック機能を有効化する場合に必要）
    # add_index :users, :unlock_token,         unique: true
  end
end
