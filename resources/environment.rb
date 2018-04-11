resource_name :rails_environment

actions :create
default_action :create

property :name, String, name_attribute: true
property :environment, Hash, default: {}
property :database_config, [NilClass, Hash], default: nil

action_class do
  include Rails::Database
end

action :create do
  environment_content =
    new_resource.environment.map { |k, v| "#{k}=#{v}" }.join("\n") + "\n"

  if new_resource.database_config
    environment_content <<
      "DATABASE_URL=" + rails_database_url(new_resource.database_config) + "\n"
  end

  file "/etc/environment" do
    content environment_content
    mode 0644
  end
end
