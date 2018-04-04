resource_name :rails_logrotate

actions :create
default_action :create

property :name, String, name_attribute: true
property :path, String
property :user, String, default: "deploy"
property :group, String, default: "deploy"
property :keep, Integer, default: 60
property :frequency, String, default: "daily"

action :create do
  logrotate_app new_resource.name do
    path new_resource.path
    options [
      "compress",
      "copytruncate",
      "dateext",
      "delaycompress",
      "missingok",
      "nocreate"
    ]
    frequency new_resource.frequency
    rotate new_resource.keep
    create "0664 #{new_resource.user} #{new_resource.group}"
  end
end
  
