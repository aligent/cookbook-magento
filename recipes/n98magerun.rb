directory "/temp/n98magerun" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end


git "/temp/n98magerun" do
  repository "https://github.com/netz98/n98-magerun.git"
  revision node['n98magerun']['revision']
  action :sync
end

bash "copy newest magerun" do
  cwd "/temp/n98magerun"
  code <<-EOF
  cp n98-magerun.phar /usr/local/bin
  chmod 755 /usr/local/bin/n98-magerun.phar
  EOF
end

