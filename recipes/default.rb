if node.has_key?("ec2")
  server_fqdn = node.ec2.public_hostname
else
  server_fqdn = node.fqdn
end

if "webmaster@localhost" == node[:magento][:admin][:email]
  admin_email = "webmaster@#{server_fqdn}"
else
  admin_email = node[:magento][:admin][:email]
end

## @TODO: Tidy this up, this is a work in progress. The canonical list of packages is for ubuntu (the default), the others should be the same.
case node[:platform_family]
when "rhel", "fedora"
  include_recipe "yum::epel"
  if node[:platform_version].to_f < 6 then
    node.set[:php][:packages] = ['php53', 'php53-devel', 'php53-cli', 'php-pear']  # TODO Incomplete
  else
    node.set[:php][:packages] = ['php', 'php-devel', 'php-cli', 'php-pear', 'php-curl', 'php-gd', 'php-mcrypt', 'php-mysql', 'php-pecl-apc']
  end
else
  node.set[:php][:packages] = ['php5-cli', 'php5-common', 'php5-curl', 'php5-gd', 'php5-mcrypt', 'php5-mysql', 'php-pear', 'php-apc', 'php-mbstring']
end
include_recipe "php::package"

template "#{node[:php][:ext_conf_dir]}/zz-aligent.ini" do
  source "zz-aligent.ini.erb"
  mode 0644
  owner "root"
  group "root"
  #notifies :run, resources(:bash => "Create Local PHP Config"), :immediately
end

if node[:magento][:gen_cfg]
  user "#{node[:magento][:user]}" do
    comment "magento guy"
    home "#{node[:magento][:dir]}"
    system true
  end
end

if node[:magento][:gen_cfg]
  user "#{node[:magento][:user]}" do
    comment "magento guy"
    home "#{node[:magento][:dir]}"
    system true
  end

  directory "#{node[:magento][:dir]}" do
    owner "#{node[:magento][:user]}"
    group "www-data"
    mode "0755"
    action :create
    recursive true
  end

  directory "#{node[:magento][:dir]}/app/etc" do
    owner "#{node[:magento][:user]}"
    group "www-data"
    mode "0755"
    action :create
    recursive true
  end
  template "#{node[:magento][:dir]}/app/etc/local.xml" do
    source "local.xml.erb"
    mode "0600"
    owner "#{node[:magento][:user]}"
    group "www-data"
    variables(:database => node[:magento][:db])
  end
end

package "bash-completion" do
  action :install
end

template "/etc/bash_completion.d/git" do
  source "git.erb"
  mode 0644
  owner "root"
  group "root"
  #notifies :run, resources(:bash => "Create Local PHP Config"), :immediately
end

