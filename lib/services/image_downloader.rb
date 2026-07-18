# frozen_string_literal: true

require 'open-uri'
require 'fileutils'

class ImageDownloader
  FOLDER_PATH = 'images/'

  def self.download(url)
    FileUtils.mkdir_p(FOLDER_PATH)

    file_path = "#{FOLDER_PATH}original_#{rand(1..30_000)}.png"

    # rubocop:disable Security/Open
    URI.open(url) do |image|
      File.binwrite(file_path, image.read)
    end
    # rubocop:enable Security/Open

    file_path
  rescue StandardError
    nil
  end
end
