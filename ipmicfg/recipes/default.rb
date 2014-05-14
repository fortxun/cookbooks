#
# Cookbook Name:: ipmicfg
# Recipe:: default
#
# Copyright 2014, PSCE
#
# All rights reserved - Do Not Redistribute
#

#ipmicfg_version = node[:ipmicfg][:version]
ipmicfg_version = "1.14.3_20130725"
ipmicfg_archive = "ipmicfg_#{ipmicfg_version}.zip"

package "unzip" do
  action :install
end

remote_file "#{Chef::Config[:file_cache_path]}/#{ipmicfg_archive}" do
  source "ftp://ftp.supermicro.com/utility/IPMICFG/#{ipmicfg_archive}"
  action :create_if_missing
end

bash "build ipmicfg-#{ipmicfg_version}" do
  code <<-EOH
unzip #{Chef::Config[:file_cache_path]}/#{ipmicfg_archive} -d /usr/local
rm -rf "/tmp/ipmicfg-#{ipmicfg_version}"
EOH
  creates "/usr/local/ipmicfg-#{ipmicfg_version}/linux/64bit/ipmicfg-linux.x86_64"
end