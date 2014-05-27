# This is a Chef attributes file. It can be used to specify default and override
# attributes to be applied to nodes that run this cookbook.


# For further information, see the Chef documentation (http://docs.opscode.com/essentials_cookbook_attribute_files.html).
default[:mta][:powermtacfg][:ip_address] = node['ipaddress']
default[:mta][:powermtacfg][:local_domain] = node['fqdn']
default[:mta][:powermtacfg][:important_domains] = "SOME_DOMAIN,SOME_DOMAIN,SOME_DOMAIN,SOME_DOMAIN,SOME_DOMAIN,SOME_DOMAIN,SOME_DOMAIN,SOME_DOMAIN"