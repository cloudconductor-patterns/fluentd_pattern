require_relative '../spec_helper'

describe 'fluentd_part::setup' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'include common recipe' do
    expect(chef_run).to include_recipe 'fluentd_part::common'
  end

  it 'install server config' do
    expect(chef_run).to create_template('/etc/td-agent/config.d/server.conf').with(
      owner: 'td-agent',
      group: 'td-agent',
      source: 'server.conf.erb',
      mode: 0755
    )
  end

  it 'create log directory' do
    ENV['ROLE'] = 'log'
    expect(chef_run).to create_directory('/var/log/td-agent/in_forward')
  end

  it 'does not create log directory' do
    ENV['ROLE'] = 'web'
    expect(chef_run).not_to create_directory('/var/log/td-agent/in_forward')
  end
end
