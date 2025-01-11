require 'carrierwave/storage/fog' # Fogを使用したAWS S3などのクラウドストレージに対応するための設定を読み込み
require 'carrierwave/orm/activerecord' # ActiveRecordとCarrierWaveの統合が必要な場合に使用（例: マウントしたカラムを扱う場合）

CarrierWave.configure do |config|
    # 本番環境でAWS S3を使用してファイルを保存する設定
    # config.storage :fog
    # config.fog_provider = 'fog/aws' # FogをAWSプロバイダとして設定
    config.fog_directory  = ENV['AWS_S3_BUCKET'] # S3のバケット名を環境変数から取得
    config.fog_credentials = {
      provider: 'AWS', # 使用するプロバイダをAWSに設定
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'], # 環境変数に保存されたAWSのアクセスキーID
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # 環境変数に保存されたAWSのシークレットキー
      region: ENV['AWS_REGION'], # 使用するAWSリージョン（例: 東京の場合はap-northeast-1）
    }
    #config.fog_public     = false # アップロードされたファイルを非公開に設定（署名付きURLを使用する場合に必要）
    config.fog_attributes = {'x-amz-acl' => nil} # 明示的にACLを無効化（バケットポリシーで管理）
	#config.storage = :file # ファイルをローカルストレージに保存　アップローダーに記載している！
end