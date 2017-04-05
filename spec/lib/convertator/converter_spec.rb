require 'spec_helper'
require 'convertator/converter'
require 'convertator/providers/static_provider'

RSpec.describe Convertator::Converter do
  def expect_d(value)
    expect(value.to_digits) 
  end

  context 'with given rates' do
    let!(:rates) do
      {
        AUD: 036,
        AZN: 43.6748_944,
        GBP: 33.3669_826,
        AMD: 70.8068_051 
      }
    end
  
    subject do
      converter = Convertator::Converter.new(:static, 7)
      converter.provider.rates = rates
      converter
    end

    it 'returns rates' do
      expect(subject.rates).to eq rates
    end

    it 'returns particular rate' do
      expect_d(subject.rate(:GBP)).to eq "33.36698"
    end

    it 'counts a valid ratio' do
      expect_d(subject.ratio(:GBP, :AMD)).to eq "0.471239701379005776421787678"
    end

    it 'converts value from one currecy to another' do
      expect_d(subject.convert(100, :GBP, :AMD)).to eq "212.206229032414680621"
    end
  end

  context 'without rates' do
    subject do
      Convertator::Converter.new(:static)
    end

    it 'raises error if currency was not found' do
      expect { subject.rate(:GBP) }.to raise_error(
        Convertator::Converter::UnknownCurrencyError
      )
    end

    describe '#load_provider' do
      it 'should load provider' do
        expect(subject.send :load_provider, :static).to be_instance_of(
          Convertator::Providers::StaticProvider
        )
      end

      it 'should raise error if not found' do

      end
    end

    describe '#normalize_currency' do
      it 'should normalize currency given as string' do
        currency = subject.send :normalize_currency, 'gbp'
        expect(currency).to eq :GBP
      end

      it 'should normalize currency given as symbol' do
        currency = subject.send :normalize_currency, :gBp 
        expect(currency).to eq :GBP
      end
    end
  end
end
