include_recipe 'td-agent'
r = resources(template: '/etc/td-agent/td-agent.conf')
r.cookbook 'fluentd_part'

directory '/etc/td-agent/config.d' do
  owner 'td-agent'
  group 'td-agent'
  mode 0755
  recursive true
  action :create
  not_if { File.exist?('/etc/td-agent/config.d') }
end

cookbook_file '/etc/init.d/td-agent' do
  source 'td-agent'
  mode 0755
end

template '/etc/td-agent/config.d/server.conf' do
  owner 'td-agent'
  group 'td-agent'
  source 'server.conf.erb'
  mode 0755
  notifies :restart, 'service[td-agent]', :delayed
end
