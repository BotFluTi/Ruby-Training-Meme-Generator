# frozen_string_literal: true

require 'active_record'
require './lib/services/password_service'

class User < ActiveRecord::Base
  attr_reader :password

  validates :username,
            presence: { message: 'is blank' },
            uniqueness: true

  validates :password,
            presence: { message: 'is blank' },
            on: :create

  validates :token, uniqueness: true

  def password=(password)
    @password = password

    return if password.nil?

    self.password_digest = PasswordService.encrypt(password)
  end

  def authenticate(password)
    return false if password_digest.nil?

    PasswordService.matches?(password, password_digest) ? self : false
  end
end
