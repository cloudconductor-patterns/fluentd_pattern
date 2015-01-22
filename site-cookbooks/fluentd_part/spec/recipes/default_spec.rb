require_relative '../spec_helper'

describe 'zabbix_part::default' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'include setup recipe' do
    expect(chef_run).to include_recipe 'zabbix_part::setup'
  end
end
