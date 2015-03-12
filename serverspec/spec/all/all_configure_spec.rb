require_relative '../spec_helper.rb'

describe service('td-agent') do
  it { should be_enabled }
end
