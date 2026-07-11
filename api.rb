# frozen_string_literal: true

require 'bundler/setup'
require 'json'
require 'sinatra'
require './lib/controllers/meme_controller'

get '/redirect' do
  redirect '/memes/meme2.jpg', 307
end


get '/memes/:file' do
  path = "#{File.dirname(__FILE__)}/images/#{params[:file]}"
  send_file(path)
end
