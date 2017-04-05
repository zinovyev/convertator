require 'spec_helper'
require 'convertator/convertor'

RSpec.describe Convertator::Convertor do
  describe '#normalize_currency' do
    subject { Convertator::Convertor.new({}) }

    it 'should normalize currency given as string' do
      currency = subject.send :normalize_currency, 'gbp'
      expect(currency).to eq :GBP
    end

    it 'should normalize currency given as symbol' do
      currency = subject.send :normalize_currency, :gBp 
      expect(currency).to eq :GBP
    end
  end

  context 'with given rates' do
    let(:rates) do
      {
        AUD: 036,
        AZN: 43.6748_944,
        GBP: 33.3669_826,
        AMD: 70.8068_051 
      }
    end 
  
    subject do
      Convertator::Convertor.new(rates)
    end

    it 'returns rates' do
      expect(subject.rates).to eq rates
    end

    it 'returns particular rate' do
      expect(subject.rate(:GBP)).to eq 33.3669_826
    end

    it 'counts a valid ratio' do
      expect(subject.ratio(:GBP, :AMD)).to eq 0.47123977070955286
    end

    it 'converts value from one currecy to another' do
      expect(subject.convert(100, :GBP, :AMD)).to eq 47.123977070955284
    end
  end

  context 'without rates' do
    subject do
      Convertator::Convertor.new({})
    end

    it 'raises error if currency was not found' do
      expect { subject.rate(:GBP) }.to raise_error(
        Convertator::Convertor::UnknownCurrencyError
      )
    end
  end
end
