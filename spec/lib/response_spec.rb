# frozen_string_literal: true

require './lib/result_data'

RSpec.describe Response do
  describe '#initialize' do
    subject(:response) do
      described_class.new(
        message: 'Something went wrong',
        redirect_url: '/memes/123.jpg'
      )
    end

    it 'stores the message' do
      expect(response.message).to eq('Something went wrong')
    end

    it 'stores the redirect URL' do
      expect(response.redirect_url).to eq('/memes/123.jpg')
    end
  end

  describe 'when initialized without arguments' do
    subject(:response) { described_class.new }

    it 'has nil message' do
      expect(response.message).to be_nil
    end

    it 'has nil redirect_url' do
      expect(response.redirect_url).to be_nil
    end
  end
end
