directory "/temp/modman" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end


git "/temp/modman" do
  repository "https://github.com/colinmollenhour/modman.git"
  revision node['modman']['revision']
  action :sync
end

bash "copy newest magerun" do
  cwd "/temp/modman"
  code <<-EOF
  cp modman /usr/local/bin
  chmod 755 /usr/local/bin/modman
  cp bash_completion /etc/bash_completion.d/modman
  chmod 644 /etc/bash_completion.d/modman
  EOF
end

package "bash-completion" do
  action :install
end


