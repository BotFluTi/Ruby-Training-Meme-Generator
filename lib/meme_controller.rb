# frozen_string_literal: true

require './lib/response'
require './lib/json_parser'
require './lib/meme_service'

class MemeController
  def execute(body)
    meme_data = JsonParser.new.parse(body)
    error_message = validation_error(meme_data)

    return Response.new(message: error_message) if error_message

    generated_path = MemeService.create(meme_data)

    return Response.new(message: 'Failed to download image') unless generated_path

    Response.new(redirect_url: File.basename(generated_path))
  end

  private

  def validation_error(meme_data)
    return 'Empty body' unless meme_data
    return 'Check URL field' if missing?(meme_data.image_url)

    'Check text field' if missing?(meme_data.text)
  end

  def missing?(value)
    value.nil? || value.empty?
  end
end
