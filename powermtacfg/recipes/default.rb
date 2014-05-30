#
# Cookbook Name:: powermtacfg
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
pmta_virtual_mtas = data_bag_item("pmta", "pmta_virtual-mtas")
pmta_domains = data_bag_item("pmta", "pmta_domains")


template "/etc/powermtacfg" do
  source "powermta_config.erb"
  mode 0440
  owner "root"
  group "root"
  variables({
     :ip_address => node[:mta][:powermtacfg][:ip_address],
     :local_domain => node[:mta][:powermtacfg][:local_domain],
     :important_domains => node[:mta][:powermtacfg][:important_domains],
     :virtualmtas => pmta_virtual_mtas,
     :domains => pmta_domains
  })
  #notifies :reload, resources(:service => "pmta")
end