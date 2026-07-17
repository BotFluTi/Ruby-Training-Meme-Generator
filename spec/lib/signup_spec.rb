# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'json'
require 'rack/test'
require 'rspec'
require './lib/user'
require_relative '../../api'

RSpec.describe 'signup' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:body) { File.read('spec/fixtures/signup_test.json') }
  let(:response_body) { JSON.parse(last_response.body) }

  before do
    User.delete_all
    post '/signup', body, { 'CONTENT_TYPE' => 'application/json' }
  end

  it 'returns status code 201' do
    expect(last_response.status).to eq(201)
  end

  it 'returns an authentication token' do
    expect(response_body.dig('user', 'token')).to be_a(String)
  end

  context 'when the username is blank' do
    let(:body) do
      File.read('spec/fixtures/signup_no_username.json')
    end

    it 'returns status code 400' do
      expect(last_response.status).to eq(400)
    end

    it 'returns a username validation error' do
      expect(response_body['errors'])
        .to include('message' => 'Username is blank')
    end
  end

  context 'when the user data is valid' do
    let(:body) { File.read('spec/fixtures/signup_test.json') }

    it 'returns status code 201' do
      expect(last_response.status).to eq(201)
    end

    it 'returns an authentication token' do
      expect(response_body.dig('user', 'token')).to be_a(String)
    end
  end

  context 'when the password is blank' do
    let(:body) do
      File.read('spec/fixtures/signup_no_password.json')
    end

    it 'returns status code 400' do
      expect(last_response.status).to eq(400)
    end

    it 'returns a password validation error' do
      expect(response_body['errors'])
        .to include('message' => 'Password is blank')
    end
  end

  context 'when the username already exists' do
    let(:body) { File.read('spec/fixtures/signup_test.json') }

    before do
      post '/signup', body, { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'returns status code 409' do
      expect(last_response.status).to eq(409)
    end
  end
end
