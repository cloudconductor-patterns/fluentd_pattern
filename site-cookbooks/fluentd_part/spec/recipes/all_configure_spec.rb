require_relative '../spec_helper'

describe 'fluentd_part::all_configure' do
  let(:chef_run) { ChefSpec::SoloRunner.new }
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
    chef_run.node.set['cloudconductor'] = {
      servers: {
        log_server: {
          roles: 'log',
          private_ip: '10.0.0.1'
        }
      },
      applications: {
        sample_app: {
        }
      }
    }

    chef_run.converge(described_recipe)
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
