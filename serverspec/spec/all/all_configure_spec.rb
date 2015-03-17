require_relative '../spec_helper.rb'

describe service('td-agent') do
  it { should be_enabled }
end

describe 'connect td-agent' do
  servers = property[:servers]

  servers.each do |svr_name, server|
    hostname = `hostname`.strip
    next unless server[:roles].include?('log')
    interface = hostname == svr_name.to_s ? '-I lo' : ''
    describe "#{svr_name} access check" do
      describe command("hping3 -S #{server[:private_ip]} -p 24224 -c 5 #{interface}") do
        its(:stdout) { should match(/sport=24224 flags=SA/) }
      end
    end
  end
end
