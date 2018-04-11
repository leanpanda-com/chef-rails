module Rails
  module Database
    OTHER = %i(encoding pool min_messages reaping_frequency timeout)

    def rails_database_url(config)
      # Symbolize keys
      symbolized = config.each.with_object({}) { |(k, v), h| h[k.to_sym] = v }

      url = "postgres://"

      if symbolized[:username]
        url << symbolized[:username]
        url << ":" + symbolized[:password] if symbolized[:password]
        url << "@"
      end

      if symbolized[:host]
        url << symbolized[:host]
      else
        url << "localhost"
      end

      url << "/" + symbolized[:name]

      url << ":" + symbolized[:port] if symbolized[:port]

      # Use symbolized.slice(*OTHER) in Ruby >= 2.5
      other = OTHER.each.with_object({}) do |k, h|
        h[k] = symbolized[k] if symbolized.key?(k)
      end

      if other.keys.count > 0
        url << "?" + other.map { |k, v| "#{k}=#{v}" }.join("&")
      end

      url
    end
  end
end
