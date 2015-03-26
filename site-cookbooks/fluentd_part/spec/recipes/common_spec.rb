require_relative '../spec_helper'

describe 'fluentd_part::common' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'include td-agent recipe' do
    expect(chef_run).to include_recipe 'td-agent'
  end

  it 'create config dir' do
    allow(File).to receive(:exist?).and_return(false)
    expect(chef_run).to create_directory('/etc/td-agent/config.d').with(
      owner: 'td-agent',
      group: 'td-agent',
      mode: 0755
    )
  end

  it 'not create config dir' do
    allow(File).to receive(:exist?).and_return(true)
    expect(chef_run).not_to create_directory('/etc/td-agent/config.d').with(
      owner: 'td-agent',
      group: 'td-agent',
      mode: 0755
    )
  end
end
