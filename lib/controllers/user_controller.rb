# frozen_string_literal: true

require 'securerandom'
require './lib/errors/existing_user_error'
require './lib/errors/validation_error'
require './lib/models/user'

class UserController
  def signup(body)
    user_data = body['user'] || {}
    username = user_data['username']

    raise ExistingUserError if User.exists?(username: username)

    user = User.new(
      username: username,
      password: user_data['password'],
      token: SecureRandom.hex(16)
    )

    raise ValidationError, validation_errors(user) unless user.save

    user
  end

  def login(body)
    credentials = body['user'] || {}
    user = User.find_by(username: credentials['username'])

    return nil unless user&.authenticate(credentials['password'])

    user
  end

  private

  def validation_errors(user)
    user.errors.full_messages.map do |message|
      { message: message }
    end
  end
end
