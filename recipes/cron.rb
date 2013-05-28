# Run Magento Crons
template "/usr/local/bin/run_crons.sh" do
  source "run_crons.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end

cron "magento" do
  minute "*/5"
  user "nginx"
  command "/usr/local/bin/run_crons.sh"
end

# CGI Killer process
template "/usr/local/sbin/kill2cgis" do
  source "kill2cgis.erb"
  owner "root"
  group "root"
  mode "0755"
end

cron "kill2cgis" do
  minute "1"
  user "root"
  command "/usr/local/sbin/kill2cgis"
end
