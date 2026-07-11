# frozen_string_literal: true

require './lib/response'
require './lib/json_parser'

class MemeController
  def execute(body)
    meme_data = JsonParser.new.parse(body)

    return Response.new(message: 'Empty body') if meme_data.nil?

    return Response.new(message: 'Check URL field') if meme_data.image_url.nil? || meme_data.image_url.empty?

    return Response.new(message: 'Check text field') if meme_data.text.nil? || meme_data.text.empty?

    Response.new(redirect_url: 'generated.jpg')
  end
end
