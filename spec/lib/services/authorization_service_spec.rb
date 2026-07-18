# frozen_string_literal: true

require './lib/services/authorization_service'

RSpec.describe AuthorizationService do
  describe '.authorized?' do
    context 'with a valid Bearer token' do
      before do
        allow(User)
          .to receive(:exists?)
          .with(token: 'valid-token')
          .and_return(true)
      end

      it 'returns true' do
        result = described_class.authorized?('Bearer valid-token')

        expect(result).to be(true)
      end
    end

    context 'with a wrong token' do
      before do
        allow(User)
          .to receive(:exists?)
          .with(token: 'invalid-token')
          .and_return(false)
      end

      it 'returns false' do
        result = described_class.authorized?('Bearer invalid-token')

        expect(result).to be(false)
      end
    end

    context 'without a header' do
      it 'returns false' do
        expect(described_class.authorized?(nil)).to be(false)
      end
    end

    context 'with a wrong authorization type' do
      it 'returns false' do
        result = described_class.authorized?('Basic valid-token')

        expect(result).to be(false)
      end
    end

    context 'with a wrong header' do
      it 'returns false' do
        result = described_class.authorized?('Bearer token extra-value')

        expect(result).to be(false)
      end
    end
  end
end
