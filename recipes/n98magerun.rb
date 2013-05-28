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
  cp autocompletion/bash/bash_complete /etc/bash_completion.d/n98-magerun
  chmod 644 /etc/bash_completion.d/n98-magerun 
  EOF
end

package "bash-completion" do
  action :install
end

