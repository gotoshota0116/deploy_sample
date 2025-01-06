class ImagesController < ApplicationController

# ogpで画像を生成し、png形式としてブラウザに送信して表示する
def ogp
  text = ogp_params[:text]  # パラメータから受け取ったテキストを取得
  image = OgpCreator.build(text).tempfile.open.read
  # OgpCreator.build で生成した画像データを一時ファイル（tempfile）として取得
  # .tempfile: MiniMagickが生成する一時ファイルへの参照
  # .open.read: 一時ファイルを開いて、画像データを読み込む（バイナリ形式）

  send_data image, type: 'image/png', disposition: 'inline'
  # send_data: Railsのコントローラーメソッド。指定したデータをHTTPレスポンスとして送信
  # type: 'image/png': レスポンスのContent-Typeを画像（PNG形式）として指定
  # disposition: 'inline': 画像をブラウザ内で直接表示（ダウンロードではなく表示）
end

  private

  def ogp_params
    params.permit(:text)
  end
end
