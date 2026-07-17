# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'rspec'
require_relative '../../api'
require './lib/user'

RSpec.describe 'Login' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe 'POST /login' do
    let(:fixture_body) { File.read('spec/fixtures/signup_test.json') }
    let(:credentials) { JSON.parse(fixture_body).fetch('user') }
    let(:body) { fixture_body }
    let(:response_body) { JSON.parse(last_response.body) }

    before do
      User.delete_all

      User.create!(
        username: credentials['username'],
        password: credentials['password'],
        token: 'test-token'
      )

      post '/login', body, { 'CONTENT_TYPE' => 'application/json' }
    end

    context 'with correct credentials' do
      it 'returns status code 200' do
        expect(last_response.status).to eq(200)
      end

      it 'returns the user token' do
        expect(response_body.dig('user', 'token')).to eq('test-token')
      end
    end

    context 'with an incorrect password' do
      let(:body) do
        {
          user: {
            username: credentials['username'],
            password: 'wrong-password'
          }
        }.to_json
      end

      it 'returns status code 409' do
        expect(last_response.status).to eq(409)
      end
    end

    context 'with an unknown username' do
      let(:body) do
        {
          user: {
            username: 'unknown-user',
            password: credentials['password']
          }
        }.to_json
      end

      it 'returns status code 409' do
        expect(last_response.status).to eq(409)
      end
    end
  end
end
