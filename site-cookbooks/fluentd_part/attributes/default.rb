include_attribute 'td-agent'
default['td_agent']['plugins'] = [
  "tail-ex",
  'forest'
]

default['fluentd_part']['server']['store_dir'] = '/var/fluentd/logs'
default['fluentd_part']['client']['pos_file'] = '/var/tmp/td-agent.log.pos'
default['fluentd_part']['client']['refresh_interval'] = 5
default['fluentd_part']['client']['flush_interval'] = '5s'
