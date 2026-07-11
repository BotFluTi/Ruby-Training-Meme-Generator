# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require_relative '../../api'

RSpec.describe 'Meme API' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'when the request is correct' do
    let(:body) { File.read('spec/fixtures/meme_test.json') }

    it 'returns status code 303' do
      post '/memes', body, { 'CONTENT_TYPE' => 'application/json' }

      expect(last_response.status).to eq(303)
    end
  end
end