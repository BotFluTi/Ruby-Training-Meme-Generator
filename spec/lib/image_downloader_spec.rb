# frozen_string_literal: true

require 'stringio'
require './lib/image_downloader'

RSpec.describe ImageDownloader do
  describe '.download' do
    let(:url) { 'https://example.com/image.png' }
    let(:image) { StringIO.new('image content') }

    before do
      allow(FileUtils).to receive(:mkdir_p)

      # rubocop:disable Security/Open
      allow(URI).to receive(:open)
        .with(url)
        .and_yield(image)

      allow(File).to receive(:binwrite)
    end
    # rubocop:enable Security/Open

    context 'when the URL is valid' do
      it 'saves the downloaded image' do
        described_class.download(url)

        expect(File).to have_received(:binwrite)
          .with(a_string_matching(%r{\Aimages/original_\d+\.png\z}), 'image content')
      end

      it 'returns the image path' do
        result = described_class.download(url)

        expect(result)
          .to match(%r{\Aimages/original_\d+\.png\z})
      end
    end

    context 'when the URL is invalid' do
      before do
        allow(URI).to receive(:open)
          .with(url)
          .and_raise(StandardError)
      end

      it 'returns nil' do
        expect(described_class.download(url)).to be_nil
      end
    end
  end
end
