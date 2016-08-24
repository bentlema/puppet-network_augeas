require 'spec_helper'
describe 'network_augeas' do

  context 'with defaults for all parameters' do
    it { should contain_class('network_augeas') }
  end
end
