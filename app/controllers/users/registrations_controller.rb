class Users::RegistrationsController < Devise::RegistrationsController
	#下記が必要かは今後判断する
	# ==========================================
	# ユーザー情報更新時の処理をカスタマイズ
	# ==========================================
	# def update_resource(resource, params)
	#   # 🔹 ユーザーがパスワードを変更しようとしている場合
	#   #    → Devise のデフォルトの `update_resource` を適用
	#   #    → `current_password` の入力を求める（セキュリティ対策のため）
	#   return super if params['password'].present?
  
	#   # 🔹 Google 認証ユーザー（OAuth ユーザー）はパスワードを持たないため、
	#   #    → `update_without_password` を使用し、パスワードなしでプロフィール情報を更新
	#   #    → `params.except('current_password')` で `current_password` を削除し、バリデーションエラーを回避
	#   resource.update_without_password(params.except('current_password'))
	# end
  end
  