# frozen_string_literal: true

require 'bundler/setup'
require 'bcrypt'
require 'json'
require 'securerandom'
require 'sinatra'
require 'sinatra/activerecord'
require './lib/meme_controller'
require './lib/user'

set :database_file, 'config/database.yml'

post '/memes' do
  body = JSON.parse(request.body.read)
  response = MemeController.new.execute(body)

  if response.message.nil?
    redirect "/memes/#{response.redirect_url}", 303
  else
    halt 400,
         { 'Content-Type' => 'application/json' },
         { message: response.message }.to_json
  end
end

get '/memes/:file' do
  path = File.join(
    __dir__,
    'images',
    File.basename(params[:file])
  )

  send_file(path)
end

post '/signup' do
  body = JSON.parse(request.body.read)
  user_data = body['user'] || {}
  username = user_data['username']
  password = user_data['password']

  if username.nil? || username.empty?
    halt 400,
         { 'Content-Type' => 'application/json' },
         { errors: [{ message: 'Username is blank' }] }.to_json
  end

  if password.nil? || password.empty?
    halt 400,
         { 'Content-Type' => 'application/json' },
         { errors: [{ message: 'Password is blank' }] }.to_json
  end

  halt 409 if User.exists?(username: username)

  token = SecureRandom.hex(16)

  User.create!(
    username: username,
    password: password,
    token: token
  )

  [
    201,
    { 'Content-Type' => 'application/json' },
    { user: { token: token } }.to_json
  ]
end

post '/login' do
  body = JSON.parse(request.body.read)
  credentials = body['user'] || {}

  user = User.find_by(username: credentials['username'])

  halt 409 unless user&.authenticate(credentials['password'])

  [
    200,
    { 'Content-Type' => 'application/json' },
    { user: { token: user.token } }.to_json
  ]
end
