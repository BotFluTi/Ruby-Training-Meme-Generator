# frozen_string_literal: true

require './lib/meme_generator'

RSpec.describe MemeGenerator do
  describe '.generate' do
    let(:file_path) { 'images/original_123.png' }
    let(:text) { 'Text for Test' }
    let(:generated_path) { 'images/generated_123.png' }
    let(:image) { instance_double(MiniMagick::Image) }

    let(:options) do
      double(
        'image options',
        gravity: nil,
        fill: nil,
        undercolor: nil,
        font: nil,
        pointsize: nil,
        draw: nil
      )
    end

    before do
      allow(MiniMagick::Image)
        .to receive(:open)
        .with(file_path)
        .and_return(image)

      allow(image)
        .to receive(:combine_options)
        .and_yield(options)

      allow(image).to receive(:write)
    end

    it 'styles and centers the text' do
      described_class.generate(file_path, text)

      expect(options).to have_received(:gravity).with('center')
      expect(options).to have_received(:fill).with('black')
      expect(options).to have_received(:undercolor).with('white')
      expect(options).to have_received(:pointsize).with(20)
      expect(options).to have_received(:draw)
        .with(%(text 0,50 "#{text}"))
    end

    it 'writes the generated image' do
      described_class.generate(file_path, text)

      expect(image)
        .to have_received(:write)
        .with(generated_path)
    end

    it 'returns the generated image path' do
      result = described_class.generate(file_path, text)

      expect(result).to eq(generated_path)
    end
  end
end
