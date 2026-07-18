# frozen_string_literal: true

require './lib/services/image_downloader'
require './lib/services/meme_generator'

class MemeService
  def self.create(meme_data)
    original_path = ImageDownloader.download(meme_data.image_url)
    return nil if original_path.nil?

    MemeGenerator.generate(original_path, meme_data.text)
  end
end
