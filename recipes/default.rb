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
case node["platform_family"]
when "rhel", "fedora"
  include_recipe "yum::epel"
  if node['platform_version'].to_f < 6 then
    node.set['php']['packages'] = ['php53', 'php53-devel', 'php53-cli', 'php-pear']  // TODO Incomplete
  else
    node.set['php']['packages'] = ['php', 'php-devel', 'php-cli', 'php-pear', 'php-curl', 'php-gd', 'php-mcrypt', 'php-mysql', 'php-pecl-apc']
  end
else
  node.set['php']['packages'] = ['php5-cli', 'php5-common', 'php5-curl', 'php5-gd', 'php5-mcrypt', 'php5-mysql', 'php-pear', 'php-apc']
end
include_recipe "php::package"

cookbook_file "#{node[:php][:conf_dir]}/php.d/zz-aligent.ini" do
  source "zz-aligent.ini"
  mode 0644
  owner "root"
  group "root"
  notifies :run, resources(:bash => "Create Local PHP Config"), :immediately
end

if node[:magento][:gen_cfg]
  user "#{node[:magento][:user]}" do
    comment "magento guy"
    home "#{node[:magento][:dir]}"
    system true
  end

#@TODO: Don't want this to automatically create a dir, should create a configurable attribute to test whether or not to do this.
#directory "#{node[:magento][:dir]}" do
#  owner "#{node[:magento][:user]}"
#  group "www-data"
#  mode "0755"
#  action :create
#  recursive true
#end
#
#if node[:magento][:gen_cfg]
#  directory "#{node[:magento][:dir]}/app/etc" do
#    owner "#{node[:magento][:user]}"
#    group "www-data"
#    mode "0755"
#    action :create
#    recursive true
#  end
#  template "#{node[:magento][:dir]}/app/etc/local.xml" do
#    source "local.xml.erb"
#    mode "0600"
#    owner "#{node[:magento][:user]}"
#    group "www-data"
#    variables(:database => node[:magento][:db])
#  end
#end
