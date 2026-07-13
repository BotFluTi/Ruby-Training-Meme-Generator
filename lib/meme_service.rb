# frozen_string_literal: true

require_relative 'image_downloader'
require_relative 'meme_generator'

class MemeService
  def self.create(meme_data)
    original_path = ImageDownloader.download(meme_data.image_url)
    return nil if original_path.nil?

    MemeGenerator.generate(original_path, meme_data.text)
  end
end
