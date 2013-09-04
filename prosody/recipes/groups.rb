case node["platform"]
when "debian", "ubuntu"
  cfg_partial_dir = "/etc/prosody/conf.d"
  cfg_dir = "/etc/prosody"
else
  Chef::Log.error("Not supported: #{node["lsb"]["name"]}")
end

template "#{cfg_partial_dir}/prosody_groups.lua" do
  source "empty.erb"
  owner "prosody"
  group "prosody"
  mode "0644"
  variables({
    :content => "groups_file = \"/var/prosody/sharedgroups.txt\""
  })
end

template "/var/prosody/sharedgroups.txt" do
  source "sharedgroups.txt.erb"
  owner "prosody"
  group "prosody"
  mode "0644"
  variables({
    :groups => node['prosody']['groups'],
  })
  notifies :restart, resources( :service => "prosody")
end
