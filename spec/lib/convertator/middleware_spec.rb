require 'spec_helper'
require 'convertator/middleware'

RSpec.describe Convertator::Middleware do
  describe '#new_rates' do
    subject { Convertator::Middleware.new }

    it 'should raise error' do
      expect { subject.call }.to raise_error NotImplementedError
    end
  end
end
