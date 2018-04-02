resource_name :rails_database

actions :create
default_action :create

property :name, String, name_attribute: true
property :username, String
property :password, String

action :create do
  postgresql_user new_resource.username do
    action :create
    password new_resource.password
  end

  postgresql_database new_resource.name do
    action :create
    owner new_resource.username
  end
end
