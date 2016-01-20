require 'spec_helper'
require 'viaggiatreno'

describe Viaggiatreno do
  describe '#version' do
    subject { Viaggiatreno::VERSION }
    it { should be_a String }
  end
end
