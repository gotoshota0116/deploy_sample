# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
# RUBY_VERSIONが.ruby-versionとGemfile内のRubyバージョンと一致していることを確認してください。
ARG RUBY_VERSION=3.2.4
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
# Railsアプリケーションがこのディレクトリに配置されます。
WORKDIR /rails

# Set production environment
# 本番環境を設定
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


# Throw-away build stage to reduce size of final image
# 最終的なイメージのサイズを削減するための一時的なビルドステージ
FROM base as build

# Install packages needed to build gems and node modules
# GemやNodeモジュールをビルドするために必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl git libpq-dev libvips node-gyp pkg-config python-is-python3

# Install JavaScript dependencies
# JavaScriptの依存関係をインストール
ARG NODE_VERSION=20.18.1
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
    /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@$YARN_VERSION && \
    rm -rf /tmp/node-build-master

# Install application gems
# アプリケーションのGemをインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Install node modules
# Nodeモジュールをインストール
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy application code
# アプリケーションのコードをコピー
COPY . .

# Precompile bootsnap code for faster boot times
# 起動時間を短縮するためにBootsnapコードをプリコンパイル
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RAILS_MASTER_KEYを必要とせずに、本番用のアセットをプリコンパイル
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
# アプリケーションイメージの最終ステージ
FROM base

# Install packages needed for deployment
# デプロイに必要なパッケージをインストール
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client imagemagick && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
# ビルド済みの成果物をコピー: Gem、アプリケーション
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
# セキュリティのため、非rootユーザーとして実行し、実行時ファイルのみを所有
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the database.
# エントリポイントでデータベースを準備
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
# デフォルトでサーバーを起動。実行時に上書き可能。
EXPOSE 3000
CMD ["./bin/rails", "server"]
