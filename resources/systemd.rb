resource_name :rails_systemd

actions :create
default_action :create

property :name, String, name_attribute: true
property :app_path, String
property :user, String, default: "deploy"
property :rails_env, String, default: "production"

action :create do
  execute "systemctl daemon-reload" do
    action :nothing
    command "systemctl daemon-reload"
  end

  service new_resource.name do
    action :nothing
    supports [:start, :stop, :restart, :status]
  end

  systemd_unit_path = ::File.join(
    "", "lib", "systemd", "system", "#{new_resource.name}.service"
  )

  template systemd_unit_path do
    source "systemd/service.erb"
    variables(
      name: new_resource.name,
      app_path: new_resource.app_path,
      rails_env: new_resource.rails_env
    )
    notifies :run, "execute[systemctl daemon-reload]", :immediately
    cookbook "rails"
  end

  commands = %w(start stop restart status enable disable).map do |action|
    "/bin/systemctl #{action} #{new_resource.name}"
  end

  file "/etc/sudoers.d/#{new_resource.user}-#{new_resource.name}" do
    content "#{new_resource.user} ALL=(ALL) NOPASSWD: #{commands.join(", ")}\n"
    mode 0440
  end
end
