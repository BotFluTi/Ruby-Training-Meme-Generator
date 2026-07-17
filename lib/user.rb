# frozen_string_literal: true

require 'bcrypt'

class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :username, presence: { message: 'is blank' }
  validates :password,
            presence: { message: 'is blank' },
            on: :create
end
