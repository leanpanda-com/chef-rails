resource_name :rails_ruby

actions :create
default_action :create

property :version, String, name_attribute: true
property :bundler_version, [String, NilClass], default: nil

action :create do
  ruby_rbenv_system_install "default"
  rbenv_ruby new_resource.version

  rbenv_gem "bundler" do
    version new_resource.bundler_version if new_resource.bundler_version
    rbenv_version new_resource.version
  end
end
