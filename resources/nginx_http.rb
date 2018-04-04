resource_name :rails_nginx_http

actions :create
default_action :create

property :name, String, default: "default_server"
property :rails_env, String, default: "production"
property :port, Integer, default: 3000
property :extras, Array, default: []

action :create do
  app_env = new_resource.name + "_" + new_resource.rails_env
  rails_upstream = app_env + "_" + "upstream"

  nginx_upstream rails_upstream do
    port new_resource.port
  end

  nginx_http_server new_resource.name do
    proxies(
      rails_upstream => %w(/)
    )
    extras new_resource.extras
    redirect_to_https false
  end
end
