require 'cgi'
require 'mime-types'

module RailsSassImages::Sass
  # Inline asset file to CSS by data-uri. Can be used for images and fonts.
  #
  #   .icon
  #     background: inline("icon.png")
  #
  #   @font-face
  #     font-family: "MyFont"
  #     src: inline("my.woff") format('woff')
  def inline(path)
    asset = RailsSassImages.asset(path)

    mime = MIME::Types.type_for(asset.to_s).first.content_type
    file = asset.read

    if mime == 'image/svg+xml'
      file     = CGI::escape(file).gsub('+', '%20')
      encoding = 'charset=utf-8'
    else
      file     = [file].flatten.pack('m').gsub("\n", '')
      encoding = 'base64'
    end

    Sass::Script::String.new("url('data:#{mime};#{encoding},#{file}')")
  end
end
