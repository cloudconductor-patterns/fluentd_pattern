require_relative 'spec_helper.rb'

describe service('td-agent') do
  it { should be_enabled }
end

describe port(24_224) do
  it { should be_listening.with('tcp') }
end
