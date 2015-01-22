require 'active_support'
::Chef::Recipe.send(:include, CloudConductor::CommonHelper)
log_servers_info = server_info('log')

include_recipe 'fluentd_part::common'
roles = ENV['ROLE'].split(',').unshift('all')

log_collection_config = {}
Dir.glob("/opt/cloudconductor/patterns/*/").each do |pattern_dir|
  log_colleciton_file = File.join(pattern_dir, 'config', 'log_collection.yml')
  next unless File.exist?(log_colleciton_file)
  log_collection_config = log_collection_config.merge((YAML.load_file(log_colleciton_file).slice(*roles))) do |_, v1, v2|
    (v1 + v2).uniq
  end
end

template '/etc/td-agent/config.d/client.conf' do
  owner 'td-agent'
  group 'td-agent'
  source 'client.conf.erb'
  mode 0755
  variables(
    log_collection_config: log_collection_config,
    log_servers_info: log_servers_info
  )
  notifies :restart, 'service[td-agent]', :delayed
end
