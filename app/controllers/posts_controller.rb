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
      params.require(:post).permit(:title, :content)
    end

    def prepare_meta_tags(post)
      ## このimage_urlにMiniMagickで設定したOGPの生成した合成画像を代入する
          image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(post.title)}"
          set_meta_tags og: {
                          site_name: '詐欺師の手帳',
                          title: post.title,
                          description: 'ユーザーによる詐欺被害の投稿です',
                          type: 'website',
                          url: request.original_url,
                          image: image_url,
                          locale: 'ja-JP'
                        },
                        twitter: {
                          card: 'summary_large_image',
                          site: '@https://x.com/gshota_0116',
                          image: image_url
                        }
    end
end
