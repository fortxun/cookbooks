#
# Cookbook Name:: ipmicfg
# Recipe:: default
#
# Copyright 2014, fortxun
#
# All rights reserved - Do Not Redistribute
#

#ipmicfg_version = node[:ipmicfg][:version]
ipmicfg_version = "1.14.3_20130725"
ipmicfg_archive = "ipmicfg_#{ipmicfg_version}.zip"

#Need unzip to open the ipmicfg archive
package "unzip" do
  action :install
end

#Download the ipmicfg archive unless its cached
remote_file "#{Chef::Config[:file_cache_path]}/#{ipmicfg_archive}" do
  source "ftp://ftp.supermicro.com/utility/IPMICFG/#{ipmicfg_archive}"
  action :create_if_missing
end

#Unzip the ipmicfg archive to /usr/local
bash "build ipmicfg-#{ipmicfg_version}" do
  code <<-EOH
unzip #{Chef::Config[:file_cache_path]}/#{ipmicfg_archive} -d /usr/local
rm -rf "/tmp/ipmicfg-#{ipmicfg_version}"
EOH
  creates "/usr/local/ipmicfg_#{ipmicfg_version}"
end

# Create a symlink to the new binary in PATH
case node['kernel']['machine']
when "x86_64"
	file "/usr/local/ipmicfg_#{ipmicfg_version}/linux/64bit/ipmicfg-linux.x86_64" do
  		mode "544"
	end
	link "/usr/local/bin/ipmicfg" do
  	to "/usr/local/ipmicfg_#{ipmicfg_version}/linux/64bit/ipmicfg-linux.x86_64"
end
when "i686"
	file "/usr/local/ipmicfg_#{ipmicfg_version}/linux/32bit/ipmicfg-linux.x86" do
  		mode "544"
	end
	link "/usr/local/bin/ipmicfg" do
  	to "/usr/local/ipmicfg_#{ipmicfg_version}/linux/32bit/ipmicfg-linux.x86"
end
else
  Chef::Log.warn("Unknown cpu arch, this recipe currently supports x86_64 and i686.")
end

#If the system has installed the OpenIPMI driver, enable the Linux IPMI driver
execute "ipmi start" do
  command "/etc/init.d/ipmi start"
  ignore_failure true
  not_if do ::File.exists?('/etc/init.d/ipmi') end
end