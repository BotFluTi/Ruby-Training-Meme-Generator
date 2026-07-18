# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe 'MemeAuth' do
  let(:body) { File.read('spec/fixtures/meme_test.json') }

  before do
    User.delete_all

    User.create!(
      username: 'burnetete',
      password: 'ananas',
      token: 'valid-token'
    )

    allow(MemeService)
      .to receive(:create)
      .and_return('images/generated_123.png')
  end

  context 'without an authorization header' do
    before do
      post '/memes', body, { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns status code 401' do
      expect(last_response.status).to eq(401)
    end
  end

  context 'with an invalid token' do
    before do
      post '/memes',
           body,
           {
             'CONTENT_TYPE' => 'application/json',
             'HTTP_AUTHORIZATION' => 'Bearer invalid-token'
           }
    end

    it 'returns status code 401' do
      expect(last_response.status).to eq(401)
    end
  end

  context 'with a valid token' do
    before do
      post '/memes',
           body,
           {
             'CONTENT_TYPE' => 'application/json',
             'HTTP_AUTHORIZATION' => 'Bearer valid-token'
           }
    end

    it 'returns status code 307' do
      expect(last_response.status).to eq(307)
    end

    it 'redirects to the generated meme' do
      expect(last_response.headers['Location'])
        .to end_with('/memes/generated_123.png')
    end
  end
end
