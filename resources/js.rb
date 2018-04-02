resource_name :rails_js

actions :create
default_action :create

property :name, String, name_property: true, default: "default"

include_recipe "nodejs"

action :create do
  apt_repository "yarn" do
    action       :add
    key          "https://dl.yarnpkg.com/debian/pubkey.gpg"
    uri          "https://dl.yarnpkg.com/debian"
    distribution "stable"
    components   ["main"]
  end

  package "yarn"
end
