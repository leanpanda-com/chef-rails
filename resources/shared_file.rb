resource_name :rails_shared_file

actions :create
default_action :create

property :base_path, String, name_attribute: true
property :path, String
property :content, String
property :user, String, default: "deploy"
property :group, String, default: "deploy"
property :mode, [Integer, String], default: 0644

action_class do
  include Rails::Paths
end

action :create do
  rails_directories new_resource.base_path do
    user new_resource.user
    group new_resource.group
  end

  shared_path = rails_shared_path(base_path: new_resource.base_path)
  file_path = ::File.join(shared_path, new_resource.path)

  file file_path do
    content new_resource.config
    user new_resource.user
    group new_resource.group
    mode new_resource.mode
  end
end
