class OgpCreator
	require 'mini_magick'

	# 下記はのちのself.buildメソッドのminimagikに渡すための定数を定義している

	# 画像のパスを記載
	BASE_IMAGE_PATH = './app/assets/images/canva_sample.jpg'
	# テキストの位置
	GRAVITY = 'center'
	# 座標の位置'X,Y'の形式
	TEXT_POSITION = '0,0'
	# フォントのパスを記載
	FONT = './app/assets/fonts/tamanegifont.ttf'
	# フォントの大きさ
	FONT_SIZE = 65
	# 1行の最大文字数
	INDENTION_COUNT = 16
	# 最大の行数
	ROW_LIMIT = 8

	# 指定されたテキストをもとに、背景画像にテキストを合成した新しい画像を生成するメソッド
	# 返り値: 合成された画像データ（MiniMagick::Imageオブジェクト）
	def self.build(text)
	  text = prepare_text(text)
	  # 下記は　minimajickの構文、メソッドを使用
	  image = MiniMagick::Image.open(BASE_IMAGE_PATH)
	  image.combine_options do |config|
		config.font FONT
		config.fill 'green'
		config.gravity GRAVITY
		config.pointsize FONT_SIZE
		config.draw "text #{TEXT_POSITION} '#{text}'"
	  end
	end

	private

	# 長いテキストを指定された文字数（INDENTION_COUNT）で改行し、
	# 行数（ROW_LIMIT）を超えないように整形するメソッド
	# 返り値: 整形されたテキスト（改行を含む文字列）
	def self.prepare_text(text)
	  text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
	# to_sはnil対策：nilが渡された場合でもエラーが起きないように文字列化
	end
  end