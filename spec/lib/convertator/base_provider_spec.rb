require 'spec_helper'
require 'convertator/base_provider'

RSpec.describe Convertator::BaseProvider do
  describe '#new_rates' do
    subject { Convertator::BaseProvider.new }

    it 'should raise error' do
      expect { subject.new_rates }.to raise_error NotImplementedError
    end
  end
end
