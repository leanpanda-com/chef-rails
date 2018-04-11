resource_name :rails_environment

actions :create
default_action :create

property :name, String, name_attribute: true
property :environment, Hash, default: {}

action :create do
  environment_content = environment.map { |k, v| "#{k}=#{v}" }.join("\n") + "\n"

  file "/etc/environment" do
    content environment_content
    mode 0644
  end
end
