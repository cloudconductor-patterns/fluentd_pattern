include_attribute 'td-agent'
default['td_agent']['plugins'] = [
  'forest',
  'tail-ex'
]
default['td_agent']['pinning_version'] = true
default['td_agent']['version'] = '2.1.5-1'
default['fluentd_part']['server']['store_dir'] = '/var/log/td-agent/in_forward'
default['fluentd_part']['client']['patterns_dir'] = '/opt/cloudconductor/patterns'
default['fluentd_part']['client']['log_config_file'] = 'config/log_collection.yml'
default['fluentd_part']['client']['pos_dir'] = '/var/log/td-agent/pos'
default['fluentd_part']['client']['pos_file'] = 'td-agent.log.pos'
default['fluentd_part']['client']['refresh_interval'] = 5
default['fluentd_part']['client']['flush_interval'] = '5s'
default['fluentd_part']['client']['target'] = {}
