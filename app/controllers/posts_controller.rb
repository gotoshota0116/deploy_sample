class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  ## 設定したprepare_meta_tagsをprivateにあってもpostコントローラー以外にも使えるようにする
  helper_method :prepare_meta_tags

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  ## メタタグを設定する。
  prepare_meta_tags(@post)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :image)
    end

    def prepare_meta_tags(post)
      ## OGP画像を取得するためのURLを構築（MiniMagickで生成される画像のエンドポイント）
      ## このURLにアクセスすると、/images/ogp.png にルーティングされ、OGP画像が動的に生成される
          image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(post.title)}"

          # setset_meta_tags は、meta-tags gem によって提供されるメソッドで、メタタグを簡潔に設定できます。
          # og:は Facebook、LinkedIn、Pinterest、Discord などのOGP対応SNSで使用される設定。
          set_meta_tags(
            title: 'まーちゃん',
            discription: 'まーちゃん大学ごめんね学部',
                          og: {
                          site_name: 'サイトの名前',
                          title: post.title,
                          description: '投稿の説明',
                          type: 'website',
                          url: request.original_url,
                          image: image_url,
                          locale: 'ja-JP'
                        },
                        # twitter:は Twitter のシェアプレビュー用設定
                        twitter: {
                          card: 'summary_large_image',
                          site: '@gshota_0116',
                          image: image_url,
                        }
          )
                        #　上記image: image_urlを表示するために、/images/ogp.pngにアクセスがいき、ogpアクションが走る！
    end
end
