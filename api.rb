# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'json'
require './lib/meme_controller'

post '/memes' do
  body = JSON.parse(request.body.read)
  response = MemeController.new.execute(body)

  if response.message.nil?
    redirect "/memes/#{response.redirect_url}", 303
  else
    [
      400,
      { 'Content-Type' => 'application/json' },
      { message: response.message }.to_json
    ]
  end
end

get '/memes/:file' do
  path = File.join(__dir__, 'images', File.basename(params[:file]))
  send_file(path)
end
