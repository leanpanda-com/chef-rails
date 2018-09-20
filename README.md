# rails Cookbook

Configure a server for a Rails application.

# Resources

* `rails_app` - sets up `rails_directories` and `rails_logrotate`
* `rails_database` - creates the application database
* `rails_environment` - sets up system-wide environment variables
* `rails_js` - installs Node.js and yarn
* `rails_nginx` - sets up Nginx for the app:
  * redirect http to https
  * obtain https certificates
  * proxy to the Rails application
* `rails_ruby` - installs a required Ruby and Bundler versions
* `rails_systemd` - manages the Rails app as a systemd service

## Secondary Resources

* `rails_directories` - creates a directory for the app, containing shared and shared/config
* `rails_logrotate` - sets up log rotation for application-specific logs
* `rails_nginx_http` -  if you **don't** want to run your app over https,
  this resource simply proxies port 80 to your Rails application port (default 3000)
* `rails_secrets` - creates `config/secrets.yml` - not needed if you use `rails_environment`
* `rails_shared_file` - creates a file under the `shared` directory

### Chef

- Chef 13.0 or later
