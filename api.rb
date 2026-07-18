# frozen_string_literal: true

require 'bundler/setup'
require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require './lib/controllers/meme_controller'
require './lib/controllers/user_controller'
require './lib/errors/existing_user_error'
require './lib/errors/validation_error'
require './lib/services/authorization_service'

set :database_file, 'config/database.yml'

error ExistingUserError do
  halt 409
end

error ValidationError do
  validation_error = env['sinatra.error']

  halt 400,
       { 'Content-Type' => 'application/json' },
       { errors: validation_error.errors }.to_json
end

post '/memes' do
  authorization_header = request.env['HTTP_AUTHORIZATION']

  halt 401 unless AuthorizationService.authorized?(authorization_header)

  body = JSON.parse(request.body.read)
  response = MemeController.new.execute(body)

  if response.message.nil?
    redirect "/memes/#{response.redirect_url}", 307
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
  user = UserController.new.signup(body)

  [
    201,
    { 'Content-Type' => 'application/json' },
    { user: { token: user.token } }.to_json
  ]
end

post '/login' do
  body = JSON.parse(request.body.read)
  user = UserController.new.login(body)

  halt 409 unless user

  [
    200,
    { 'Content-Type' => 'application/json' },
    { user: { token: user.token } }.to_json
  ]
end
