simple_iptables_rule "in" do
  rule [
    "-p tcp --dport 22",
    "-m state --state RELATED,ESTABLISHED",
    "-p tcp --dport 80 -m state --state NEW",
    "--proto tcp --dport 443 -m state --state NEW",
    "-i lo"
  ]
  jump "ACCEPT"
end

simple_iptables_policy "INPUT" do
  policy "DROP"
end

simple_iptables_policy "FORWARD" do
  policy "DROP"
end

