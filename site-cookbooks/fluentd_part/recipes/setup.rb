include_recipe 'fluentd_part::common'

template '/etc/td-agent/config.d/server.conf' do
  owner 'td-agent'
  group 'td-agent'
  source 'server.conf.erb'
  mode 0755
  notifies :restart, 'service[td-agent]', :delayed
end

roles = [] + (node['fluentd_part']['roles'] || [])
roles = ENV['ROLE'].split(',') if ENV['ROLE']
directory node['fluentd_part']['server']['store_dir'] do
  mode 0755
  recursive true
  action :create
  only_if { roles.include?('log') }
end
