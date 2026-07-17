# frozen_string_literal: true

require 'active_record'
require 'bcrypt'

class User < ActiveRecord::Base
  has_secure_password validations: false

  validates :username,
            presence: { message: 'is blank' },
            uniqueness: true

  validates :password,
            presence: { message: 'is blank' },
            on: :create

  validates :token, uniqueness: true
end
