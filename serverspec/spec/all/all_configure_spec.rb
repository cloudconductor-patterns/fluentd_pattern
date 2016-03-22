require_relative '../spec_helper.rb'

describe service('td-agent') do
  it { should be_enabled }
end

describe 'connect td-agent' do
  servers = property[:servers]

  servers.each do |_, server|
    next unless server[:roles].include?('log')
    describe "#{svr_name} access check" do
      describe host(server[:private_ip]) do
        it { should be_reachable.with(port: 24224) }
      end
    end
  end
end
