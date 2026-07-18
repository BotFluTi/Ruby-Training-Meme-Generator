# frozen_string_literal: true

require './lib/models/meme_data'

class JsonParser
  def parse(body)
    return nil if body.nil? || body.empty?

    root = body['meme']
    return nil if root.nil? || root.empty?

    MemeData.new(root['image_url'], root['text'])
  end
end
