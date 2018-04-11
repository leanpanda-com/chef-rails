resource_name :rails_app

actions :create
default_action :create

property :base_path, String, name_attribute: true
property :rails_env, String, default: "production"
property :user, String, default: "deploy"
property :group, String, default: "deploy"

action_class do
  include Rails::Paths
end

action :create do
  rails_directories new_resource.base_path do
    user new_resource.user
    group new_resource.group
  end

  shared_path = rails_shared_path(base_path: new_resource.base_path)
  log_path_base = ::File.join(shared_path, "log")
  log_name_base =
    new_resource.base_path.sub(%r{/}, "").tr("/", "_")

  rails_logrotate log_name_base + "_rails" do
    path ::File.join(log_path_base, "#{new_resource.rails_env}.log")
    user new_resource.user
    group new_resource.group
  end

  rails_logrotate log_name_base + "_puma_access" do
    path ::File.join(log_path_base, "puma_access.log")
    user new_resource.user
    group new_resource.group
    only_if { node["rails"]["server"] == "puma" }
  end

  rails_logrotate log_name_base + "_puma_error" do
    path ::File.join(log_path_base, "puma_error.log")
    user new_resource.user
    group new_resource.group
    only_if { node["rails"]["server"] == "puma" }
  end
end
