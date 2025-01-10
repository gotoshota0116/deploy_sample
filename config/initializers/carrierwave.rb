require 'carrierwave/storage/fog'
# require 'carrierwave/orm/activerecord' # ActiveRecordとの統合が必要な場合

CarrierWave.configure do |config|
	if Rails.env.production?
    # config.storage :fog
    	config.fog_provider = 'fog/aws'
    	config.fog_directory  = ENV['AWS_S3_BUCKET'] # envファイルで設定
    	config.fog_credentials = {
    	  provider: 'AWS',
    	  aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'], # 環境変数
    	  aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'], # 環境変数
    	  region: ENV['AWS_REGION'],   # アジアパシフィック(東京)を選択した場合
    	}
	else
	  # 開発環境/テスト環境: ローカルストレージを使用
      config.storage = :file
      config.enable_processing = Rails.env.development? # 開発時のみ画像処理を有効化
  	end
end

