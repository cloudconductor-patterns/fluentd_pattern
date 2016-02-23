execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

yum_package 'initscripts'

cookbook_file '/etc/sysconfig/td-agent' do
  source 'td-agent'
  mode 0755
end

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
