require 'spec_helper'
describe 'route53' do
  context 'with default values for all parameters' do
    it { should contain_class('route53') }
  end
end
