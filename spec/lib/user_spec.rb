# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../../api'
require './lib/user'

RSpec.describe User do
  describe 'validations' do
    context 'without a username' do
      subject(:user) do
        described_class.new(
          username: '',
          password: 'ananas',
          token: 'test-token'
        )
      end

      it 'is invalid' do
        expect(user).not_to be_valid
      end

      it 'contains a username validation error' do
        user.validate

        expect(user.errors.full_messages).to include('Username is blank')
      end
    end

    context 'without a password' do
      subject(:user) do
        described_class.new(
          username: 'burnetete',
          token: 'test-token'
        )
      end

      it 'is invalid' do
        expect(user).not_to be_valid
      end

      it 'contains a password validation error' do
        user.validate

        expect(user.errors.full_messages).to include('Password is blank')
      end
    end

    context 'with a duplicate username' do
      subject(:user) do
        described_class.new(
          username: 'burnetete',
          password: 'ananas',
          token: 'second-token'
        )
      end

      before do
        described_class.delete_all

        described_class.create!(
          username: 'burnetete',
          password: 'ananas',
          token: 'first-token'
        )
      end

      it 'is invalid' do
        expect(user).not_to be_valid
      end
    end

    context 'with a duplicate token' do
      subject(:user) do
        described_class.new(
          username: 'second-user',
          password: 'ananas',
          token: 'same-token'
        )
      end

      before do
        described_class.delete_all

        described_class.create!(
          username: 'burnetete',
          password: 'ananas',
          token: 'same-token'
        )
      end

      it 'is invalid' do
        expect(user).not_to be_valid
      end
    end
  end

  describe 'password security' do
    subject(:user) { described_class.new(password: password) }

    let(:password) { 'ananas' }

    it 'stores the password as a BCrypt hash' do
      hashed_password = BCrypt::Password.new(user.password_digest)

      expect(hashed_password).to eq(password)
    end

    it 'authenticates the correct password' do
      expect(user.authenticate(password)).to eq(user)
    end

    it 'rejects an incorrect password' do
      expect(user.authenticate('wrong-password')).to be(false)
    end
  end
end
