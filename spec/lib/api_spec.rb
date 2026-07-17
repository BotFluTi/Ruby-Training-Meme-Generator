# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require_relative '../../api'
require_relative '../../lib/user'

RSpec.describe 'MemeData' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:service_result) { 'images/generated_123.png' }

  before do
    User.delete_all

    User.create!(
      username: 'burnetete',
      password: 'ananas',
      token: 'valid-token'
    )

    allow(MemeService)
      .to receive(:create)
      .and_return(service_result)

    post '/memes',
         body,
         {
           'CONTENT_TYPE' => 'application/json',
           'HTTP_AUTHORIZATION' => 'Bearer valid-token'
         }
  end

  context 'when the request is correct' do
    let(:body) { File.read('spec/fixtures/meme_test.json') }

    it 'returns status code 307' do
      expect(last_response.status).to eq(307)
    end
  end

  context 'when the request is missing the image URL' do
    let(:body) { File.read('spec/fixtures/no_link_test.json') }
    let(:response_body) { JSON.parse(last_response.body) }

    it 'returns status code 400' do
      expect(last_response.status).to eq(400)
    end

    it 'returns an error message' do
      expect(response_body['message']).to include('Check URL field')
    end
  end

  context 'when the request is missing text' do
    let(:body) { File.read('spec/fixtures/no_text_test.json') }
    let(:response_body) { JSON.parse(last_response.body) }

    it 'returns status code 400' do
      expect(last_response.status).to eq(400)
    end

    it 'returns an error message' do
      expect(response_body['message']).to include('Check text field')
    end
  end

  context 'when the request body is empty' do
    let(:body) { File.read('spec/fixtures/empty_json_test.json') }
    let(:response_body) { JSON.parse(last_response.body) }

    it 'returns status code 400' do
      expect(last_response.status).to eq(400)
    end

    it 'returns an error message' do
      expect(response_body['message']).to include('Empty body')
    end
  end
end
