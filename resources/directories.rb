resource_name :rails_directories

actions :create
default_action :create

property :base_path, String, name_attribute: true
property :user, String, default: "deploy"
property :group, String, default: "deploy"

action_class do
  include Rails::Paths
end

action :create do
  directory new_resource.base_path do
    recursive true
    user new_resource.user
    group new_resource.group
    mode 0755
  end

  directory rails_shared_path(base_path: new_resource.base_path) do
    user new_resource.user
    group new_resource.group
    mode 0755
  end

  directory rails_config_path(base_path: new_resource.base_path) do
    user new_resource.user
    group new_resource.group
    mode 0755
  end
end
