# frozen_string_literal: true

require './lib/services/password_service'

RSpec.describe PasswordService do
  describe '.encrypt' do
    it 'returns a BCrypt hash' do
      encrypted_password = described_class.encrypt('ananas')

      expect(BCrypt::Password.new(encrypted_password)).to eq('ananas')
    end
  end

  describe '.matches?' do
    let(:encrypted_password) do
      described_class.encrypt('ananas')
    end

    it 'accepts the correct password' do
      result = described_class.matches?('ananas', encrypted_password)

      expect(result).to be(true)
    end

    it 'rejects an incorrect password' do
      result = described_class.matches?('wrong-password', encrypted_password)

      expect(result).to be(false)
    end
  end
end
