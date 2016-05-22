require 'shellwords'

class Sizer

  # All subroutines return [x, y]
  # Sizing options include OS X-native file and sips commands, ImageMagick's identify, the Dimensions gem (via http://hints.macworld.com/article.php?story=20031124140353993)
  def self.size(path)
    size_via_sips(path)
  end

    def self.size_via_sips(path)
      xy = `sips -g pixelHeight -g pixelWidth #{Shellwords.escape(path)} 2>>#{IMATAGEN_LOG}`
      matches = xy.scan(/[0-9]+/)
      [matches[-1].to_i, matches[-2].to_i]
    end
end
