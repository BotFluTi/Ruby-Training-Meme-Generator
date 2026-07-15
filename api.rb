# frozen_string_literal: true

require 'bundler/setup'
require 'bcrypt'
require 'json'
require 'securerandom'
require 'sinatra'
require 'sinatra/activerecord'
require './lib/meme_controller'

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
  user = body['user'] || {}
  username = user['username']
  password = user['password']

  if username.nil? || username.empty?
    halt 400,
         { 'Content-Type' => 'application/json' },
         {
           errors: [
             { message: 'Username is blank' }
           ]
         }.to_json
  end

  if password.nil? || password.empty?
    halt 400,
         { 'Content-Type' => 'application/json' },
         {
           errors: [
             { message: 'Password is blank' }
           ]
         }.to_json
  end

  token = SecureRandom.hex(16)

  [
    201,
    { 'Content-Type' => 'application/json' },
    { user: { token: token } }.to_json
  ]
end
