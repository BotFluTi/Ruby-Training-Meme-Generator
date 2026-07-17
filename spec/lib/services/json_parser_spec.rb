# frozen_string_literal: true

require './lib/services/json_parser'
require './lib/models/meme_data'

RSpec.describe JsonParser do
  describe '#parse' do
    subject(:result) { described_class.new.parse(body) }

    let(:body) do
      {
        'meme' => {
          'image_url' => 'https://example.com/image.jpg',
          'text' => 'Hello world'
        }
      }
    end

    it 'returns meme data' do
      expect(result).to be_a(MemeData)
    end

    it 'returns the image URL' do
      expect(result.image_url).to eq('https://example.com/image.jpg')
    end

    it 'returns the text' do
      expect(result.text).to eq('Hello world')
    end
  end
end
