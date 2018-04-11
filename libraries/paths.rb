module Rails
  module Paths
    def rails_shared_path(base_path:)
      ::File.join(base_path, "shared")
    end

    def rails_config_path(base_path:)
      ::File.join(rails_shared_path(base_path: base_path), "config")
    end
  end
end
