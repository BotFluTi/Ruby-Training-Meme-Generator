# frozen_string_literal: true

require './spec/spec_helper'
require './lib/controllers/user_controller'

RSpec.describe UserController do
  subject(:controller) { described_class.new }

  shared_examples 'invalid signup data' do |message|
    let(:validation_error) do
      controller.signup(body)
    rescue ValidationError => e
      e
    end

    it 'raises the expected validation error' do
      expect(validation_error.errors).to include(message: message)
    end

    it 'does not access the database' do
      allow(User).to receive(:exists?)

      validation_error

      expect(User).not_to have_received(:exists?)
    end
  end

  describe '#signup' do
    context 'when username is missing' do
      let(:body) do
        {
          'user' => {
            'password' => 'ananas'
          }
        }
      end

      it_behaves_like 'invalid signup data', 'Username is blank'
    end

    context 'when password is missing' do
      let(:body) do
        {
          'user' => {
            'username' => 'burnetete'
          }
        }
      end

      it_behaves_like 'invalid signup data', 'Password is blank'
    end
  end
end
