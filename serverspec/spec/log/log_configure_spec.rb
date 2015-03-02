require_relative '../spec_helper.rb'

describe service('td-agent') do
  it { should be_enabled }
end

describe port(24_224) do
  it { should be_listening.with('tcp') }
end

describe 'connect td-agent' do
  servers = property[:servers]

  servers.each do |svr_name, server|
    next unless server[:roles] == 'log'
    describe "#{svr_name} access check" do
      describe command("hping3 -S #{server[:private_ip]} -p 24224 -c 5") do
        its(:stdout) { should match '/sport=24224 flags=SA/' }
      end
    end
  end
end
