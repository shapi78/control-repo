require 'spec_helper'
describe 'mssql' do
  context 'with default values for all parameters' do
    it { should contain_class('mssql') }
  end
end
