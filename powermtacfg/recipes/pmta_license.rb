#
# Cookbook Name:: powermtacfg
# Recipe:: pmta_license



license_file_contents = NIL
if Chef::DataBag.list.key?('pmta')
	Chef::Log.warn("Found pmta_licenses data bag...")
begin
	license_file_contents = data_bag_item("pmta", "pmta_licenses")['#{hostname}']
	Chef::Log.warn("found hostname license in data bag...")
	file "/etc/pmta/license" do
	owner 'root'
	group 'root'
	mode 0640
	action :create
	content license_file_contents
end
rescue Net::HTTPServerException
	Chef::Log.warn("HTTP Server exception, assuming hostname record not in databag...")
end
begin
	if license_file_contents.nil?
	license_file_contents = data_bag_item("pmta", "pmta_licenses")['default']
	Chef::Log.warn("Found default license in data bag...")
	file "/etc/pmta/license" do
	owner 'root'
	group 'root'
	mode 0640
	action :create
	content license_file_contents
	end
end
rescue Net::HTTPServerException
	Chef::Log.warn("HTTP Server exception, assuming default_license record not in databag...")
end
	else
	Chef::Log.warn("No data bag found; using cookbook_file for license...")
	cookbook_file "/etc/pmta/license" do
	owner 'root'
	group 'root'
	mode 0644
	action :create
	source 'license'
	end
end