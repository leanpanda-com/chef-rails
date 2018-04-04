resource_name :rails_app

actions :create
default_action :create

property :base_path, String, name_attribute: true
property :rails_env, String, default: "production"
property :master_key, String
property :database_config, Hash
property :user, String
property :group, String

DEFAULT_DATABASE_CONFIG = {
  "adapter" => "postgresql",
  "port" => 5432,
  "encoding" => "utf8",
  "pool" => 5,
  "min_messages" => "warning",
  "reaping_frequency" => 10,
  "timeout" => 5000
}.freeze

action :create do
  directory new_resource.base_path do
    recursive true
    user new_resource.user
    group new_resource.group
    mode 0755
  end

  shared_path = ::File.join(new_resource.base_path, "shared")

  directory shared_path do
    user new_resource.user
    group new_resource.group
    mode 0755
  end

  config_path = ::File.join(shared_path, "config")

  directory config_path do
    user new_resource.user
    group new_resource.group
    mode 0755
  end

  database_yml_path = ::File.join(config_path, "database.yml")

  database_env_config = DEFAULT_DATABASE_CONFIG.merge(
    new_resource.database_config
  )
  full_config = {new_resource.rails_env => database_env_config}

  file database_yml_path do
    content full_config.to_yaml
    user new_resource.user
    group new_resource.group
    mode 0600
  end

  master_key_path = ::File.join(config_path, "master.key")

  file master_key_path do
    content new_resource.master_key
    user new_resource.user
    group new_resource.group
    mode 0600
    only_if { node["rails"]["version"] >= "5.2" }
  end

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
