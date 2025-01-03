# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cosensee::BracketParser do
  let(:parser) { Cosensee::BracketParser.new }

  describe '#parse' do
    context 'when parsing an empty bracket' do
      let(:content) { [''] }
      let(:result) { parser.parse(content) }

      it 'returns an EmptyBracket instance' do
        expect(result.class).to eq Cosensee::EmptyBracket
      end

      it 'has the correct content' do
        expect(result.content).to eq(content)
      end
    end

    context 'when parsing a blank bracket' do
      let(:content) { [' '] }
      let(:result) { parser.parse(content) }

      it 'returns a BlankBracket instance' do
        expect(result.class).to eq Cosensee::BlankBracket
      end

      it 'has the correct content' do
        expect(result.content).to eq(content)
      end

      it 'has the correct blank' do
        expect(result.blank).to eq(' ')
      end
    end

    context 'when parsing a math bracket' do
      let(:content) { ['$ a+b'] }
      let(:result) { parser.parse(content) }

      it 'returns a FormulaBracket instance' do
        expect(result.class).to eq Cosensee::FormulaBracket
      end
    end

    context 'when parsing an external link with the link preceding the anchor' do
      let(:content) { ['http://example.com Example'] }
      let(:result) { parser.parse(content) }

      it 'returns an ExternalLinkBracket instance' do
        expect(result.class).to eq(Cosensee::ExternalLinkBracket)
      end

      it 'has the correct content' do
        expect(result.content).to eq(content)
      end

      it 'has the correct link' do
        expect(result.link).to eq('http://example.com')
      end

      it 'has the correct anchor' do
        expect(result.anchor).to eq('Example')
      end
    end

    context 'when parsing an external link with the anchor preceding the link' do
      let(:content) { ['Example http://example.com'] }
      let(:result) { parser.parse(content) }

      it 'returns an ExternalLinkBracket instance' do
        expect(result.class).to eq(Cosensee::ExternalLinkBracket)
      end

      it 'has the correct link' do
        expect(result.link).to eq('http://example.com')
      end

      it 'has the correct anchor' do
        expect(result.anchor).to eq('Example')
      end
    end

    context 'when parsing a decorate bracket' do
      let(:content) { ['*/*_* bold text'] }
      let(:result) { parser.parse(content) }

      it 'returns a DecorateBracket instance' do
        expect(result.class).to eq Cosensee::DecorateBracket
      end

      it 'has the correct content' do
        expect(result.content).to eq(content)
      end

      it 'has the correct font size' do
        expect(result.font_size).to eq(3)
      end

      it 'is not underlined' do
        expect(result.underlined).to be true
      end

      it 'is not deleted' do
        expect(result.deleted).to be false
      end

      it 'is not slanted' do
        expect(result.slanted).to be true
      end

      it 'has the correct text' do
        expect(result.text).to eq('bold text')
      end
    end

    context 'when parsing an icon bracket' do
      let(:content) { ['example.icon'] }
      let(:result) { parser.parse(content) }

      it 'returns an IconBracket instance' do
        expect(result.class).to eq(Cosensee::IconBracket)
      end
    end

    context 'when parsing an internal link bracket' do
      let(:content) { ['internal'] }
      let(:result) { parser.parse(content) }

      it 'returns an InternalLinkBracket instance' do
        expect(result.class).to eq Cosensee::InternalLinkBracket
      end

      it 'has the correct link' do
        expect(result.link).to eq('internal.html')
      end

      it 'has the correct anchor' do
        expect(result.anchor).to eq('internal')
      end
    end

    context 'when parsing a text bracket' do
      let(:content) { ['mixed', Cosensee::Code.new('foo')] }
      let(:result) { parser.parse(content) }

      it 'returns a TextBracket instance' do
        expect(result.class).to eq Cosensee::TextBracket
      end

      it 'has the correct content' do
        expect(result.content).to eq(content)
      end
    end

    context 'when parsing an image bracket with link first' do
      let(:content) { ['http://example.com/link https://example.com/example.jpg'] }
      let(:result) { parser.parse(content) }

      it 'returns an ImageBracket instance' do
        expect(result.class).to eq Cosensee::ImageBracket
      end

      it 'has the correct link' do
        expect(result.link).to eq('http://example.com/link')
      end

      it 'has the correct src' do
        expect(result.src).to eq('https://example.com/example.jpg')
      end
    end

    context 'when parsing an image bracket with src first' do
      let(:content) { ['https://example.com/example.jpg http://example.com/link'] }
      let(:result) { parser.parse(content) }

      it 'returns an ImageBracket instance' do
        expect(result.class).to eq Cosensee::ImageBracket
      end

      it 'has the correct link' do
        expect(result.link).to eq('http://example.com/link')
      end

      it 'has the correct src' do
        expect(result.src).to eq('https://example.com/example.jpg')
      end
    end
  end
end
