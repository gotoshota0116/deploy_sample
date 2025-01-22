require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  config.storage :fog
  config.fog_provider = 'fog/aws'
  config.fog_directory = ENV.fetch('S3_BUCKET_NAME', nil) # 作成したバケット名を記述
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID', nil), # 環境変数
    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY', nil), # 環境変数
    region: ENV.fetch('S3_REGION', nil), # アジアパシフィック(東京)を選択した場合
    path_style: true
  }
  # config.fog_attributes = { 'x-amz-acl' => nil } # 明示的にACLを無効化　バケットの設定でブロックしているためこの記載はいらない
  config.fog_public = false # ファイルを非公開にする
end
