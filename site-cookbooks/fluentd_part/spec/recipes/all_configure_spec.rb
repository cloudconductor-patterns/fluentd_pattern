require_relative '../spec_helper'

describe 'fluentd_part::all_configure' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'install client config file' do
    expect(chef_run).to create_template('/etc/td-agent/config.d/client.conf').with(
      owner: 'td-agent',
      group: 'td-agent',
      source: 'client.conf.erb',
      mode: 0755
    )
  end
end
