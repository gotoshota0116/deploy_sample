class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # :omniauthable を有効にすると、OmniAuth を使った外部サービス（Google, Facebook など）による認証が可能になる
  # `omniauth_providers: [:google_oauth2]` で、Google OAuth2 認証を有効化

  validates :uid, uniqueness: { scope: :provider }, allow_nil: true
  # `uid` はプロバイダー（Google, Facebook など）ごとに一意である必要がある
  # 通常のメール & パスワード登録時は `uid: nil` になるため、`allow_nil: true` でバリデーションをスキップ

  # 最初にemailとパスワードで登録したのちに、googleログインを使用とした場合、google認証情報を既存のユーザーに紐づける処理する
  # deviseのデフォルトバリデーションで、emailのユニークが設定されているため、同じメールアドレスのユーザー作成はできない
  def self.from_omniauth(auth)
    # まず `provider` & `uid` でユーザーを検索
    user = where(provider: auth.provider, uid: auth.uid).first

    # すでに Google 認証済みのユーザーがいるなら、それを返す
    return user if user.present?

    # 既存の `email` を持つユーザーを検索（メール & パスワード登録済みユーザー）
    user = find_by(email: auth.info.email)
    if user
      # 🔹 既存ユーザーに Google 認証情報を紐付ける
      user.update(provider: auth.provider, uid: auth.uid)
    else
      # 🔹 それ以外の場合、新規作成
      user = create(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        name: auth.info.name,
        password: Devise.friendly_token[0, 20]
        # user.avatar = auth.info.image
         user.skip_confirmation! #メール認証をじっそうしたときにこの記載が必要
      )
    end
    user
  end
end
