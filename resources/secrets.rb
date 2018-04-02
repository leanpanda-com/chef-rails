resource_name :rails_secrets

actions :create
default_action :create

property :base_path, String, name_attribute: true
property :rails_env, String, default: "production"
property :secrets, Hash
property :user, String
property :group, String

action :create do
  config_path = ::File.join(new_resource.base_path, "shared", "config")
  secrets_yml_path = ::File.join(config_path, "secrets.yml")
  full_secrets = {new_resource.rails_env => secrets}

  file secrets_yml_path do
    content full_secrets.to_yaml
    user new_resource.user
    group new_resource.group
    mode 0600
  end
end
