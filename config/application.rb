require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Dotenv::Rails.load #クレデンシャル使ったからコメントアウト！

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # タイムゾーンを日本時間（JST）に設定
    config.time_zone = 'Tokyo'

    # データベースには UTC で保存し、アプリ側で JST に変換
    config.active_record.default_timezone = :utc

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.helper false             # helper ファイルを作成しない
      g.test_framework false     # test ファイルを作成しない
      g.skip_routes true         # ルーティングの記述を作成しない
    end
  end
end
