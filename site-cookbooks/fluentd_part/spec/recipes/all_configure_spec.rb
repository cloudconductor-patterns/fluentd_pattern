require_relative '../spec_helper'
require 'cloud_conductor_utils/consul'

describe 'fluentd_part::all_configure' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }
  let(:cloudconductor_parameters) do
    {
      cloudconductor: {
        applications: {
          sample_app: {
          }
        }
      }
    }
  end

  before do
    ENV['ROLE'] = 'web'
    allow(CloudConductorUtils::Consul).to receive(:read_parameters).and_return(cloudconductor_parameters)
  end

  it 'create pos_dir' do
    allow(File).to receive(:exist?).and_return(false)
    expect(chef_run).to create_directory('/var/log/td-agent/pos').with(
      owner: 'td-agent',
      group: 'td-agent',
      mode: 0755,
      recursive: true
    )
  end

  it 'include common recipe' do
    expect(chef_run).to include_recipe 'fluentd_part::common'
  end

  it 'install client config file' do
    expect(chef_run).to create_template('/etc/td-agent/config.d/client.conf').with(
      owner: 'td-agent',
      group: 'td-agent',
      source: 'client.conf.erb',
      mode: 0755
    )
  end
end
