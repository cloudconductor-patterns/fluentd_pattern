::Chef::Recipe.send(:include, CloudConductor::CommonHelper)
log_servers_info = server_info('log')

directory node['fluentd_part']['client']['pos_dir'] do
  owner 'td-agent'
  group 'td-agent'
  mode 0755
  recursive true
  action :create
  not_if { File.exist?(node['fluentd_part']['client']['pos_dir']) }
end

include_recipe 'fluentd_part::common'
patterns_dir = File.join(node['fluentd_part']['client']['patterns_dir'], '*')
log_collection_config = Dir.glob(patterns_dir).inject({}) do |result, pattern_dir|
  log_colleciton_file = File.join(pattern_dir, node['fluentd_part']['client']['log_config_file'])
  next result unless File.exist?(log_colleciton_file)
  ::Chef::Mixin::DeepMerge.deep_merge!(YAML.load_file(log_colleciton_file), result)
end

parameters = node['cloudconductor']
applications = parameters[:applications] || {}
deploy_log_collection_config = applications.inject({}) do |result, (_application_name, application)|
  next result if application[:parameters].nil? || application[:parameters][:log_collection].nil?
  application_config = application[:parameters][:log_collection].inject({}) do |role_config, (role, paths)|
    ::Chef::Mixin::DeepMerge.deep_merge!(
      {
        role.to_s => paths
      },
      role_config
    )
  end
  ::Chef::Mixin::DeepMerge.deep_merge!(application_config, result)
end
::Chef::Mixin::DeepMerge.deep_merge!(deploy_log_collection_config, log_collection_config)
::Chef::Mixin::DeepMerge.deep_merge!(node['fluentd_part']['client']['target'], log_collection_config)

roles = [] + (node['fluentd_part']['roles'] || [])
roles = ENV['ROLE'].split(',') if ENV['ROLE']
roles.unshift('all')
log_collection_config.select! do |key|
  key if roles.include?(key)
end

template '/etc/td-agent/config.d/client.conf' do
  owner 'td-agent'
  group 'td-agent'
  source 'client.conf.erb'
  mode 0755
  variables(
    roles: roles,
    log_collection_config: log_collection_config,
    log_servers_info: log_servers_info,
    pos_file: File.join(
      node['fluentd_part']['client']['pos_dir'],
      node['fluentd_part']['client']['pos_file']
    )
  )
  notifies :restart, 'service[td-agent]', :delayed
end
