require_relative '../spec_helper'

describe 'fluentd_part::setup' do
  let(:chef_run) { ChefSpec::SoloRunner.new }

  before do
    chef_run.converge(described_recipe)
  end

  it 'install client config file' do
    expect(chef_run).to create_template('/etc/td-agent/config.d/client.conf').with(
      owner: 'td-agent',
      grouo: 'td-agent',
      source: 'client.conf.erb',
      mode: 0755
    )
  end

end
