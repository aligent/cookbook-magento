%w{pv}.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file '/usr/local/bin/n98-magerun.phar' do
  source 'https://files.magerun.net/n98-magerun.phar'
  owner 'root'
  group 'root'
  mode '755'
end
