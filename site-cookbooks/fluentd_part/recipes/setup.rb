include_recipe 'fluentd_part::common'

template '/etc/td-agent/config.d/server.conf' do
  owner 'td-agent'
  group 'td-agent'
  source 'server.conf.erb'
  mode 0755
  notifies :restart, 'service[td-agent]', :delayed
end
