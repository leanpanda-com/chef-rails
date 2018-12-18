resource_name :rails_nginx

actions :create
default_action :create

property :name, String, default: "default_server"
property :rails_env, String, default: "production"
property :port, Integer, default: 3000
property :ssl_certificate_path, [String, nil]
property :ssl_key_path, [String, nil]
property :extras, Array, default: []

action :create do
  nginx_http_server do
    default_server true
    redirect_to_https true
  end

  app_env = new_resource.name + "_" + new_resource.rails_env
  rails_upstream = app_env + "_" + "upstream"

  nginx_upstream rails_upstream do
    port new_resource.port
  end

  nginx_https_server new_resource.name do
    proxies(
      rails_upstream => %w(/)
    )
    ssl_certificate_path new_resource.ssl_certificate_path
    ssl_key_path new_resource.ssl_key_path
    extras new_resource.extras
  end
end
