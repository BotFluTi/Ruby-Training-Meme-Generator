# frozen_string_literal: true

require 'securerandom'
require './lib/errors/existing_user_error'
require './lib/errors/validation_error'
require './lib/models/user'

class UserController
  def signup(body)
    user_data = body['user'] || {}

    validate_user_data!(user_data)

    raise ExistingUserError if User.exists?(username: user_data['username'])

    user = build_user(user_data)

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

  def validate_user_data!(user_data)
    errors = []

    errors << { message: 'Username is blank' } if user_data['username'].nil? || user_data['username'].empty?

    errors << { message: 'Password is blank' } if user_data['password'].nil? || user_data['password'].empty?

    raise ValidationError, errors unless errors.empty?
  end

  def validation_errors(user)
    user.errors.full_messages.map do |message|
      { message: message }
    end
  end

  def build_user(user_data)
    User.new(
      username: user_data['username'],
      password: user_data['password'],
      token: SecureRandom.hex(16)
    )
  end
end
