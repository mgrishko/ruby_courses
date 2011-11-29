module SubdomainMethods

  # Sets Capybara app_host to current subdomain
  #
  # In order to get it working it is necessary to configure hosts file or proxy:
  #   127.0.0.1   app.example.com
  #   127.0.0.1   company.example.com
  #   127.0.0.1   othercompany.example.com
  #
  # @param [String] subdomain
  def set_current_subdomain(subdomain)
    Capybara.app_host = "http://#{subdomain}.example.com:#{Capybara.server_port}"
  end

  def extract_port(url)
    url.gsub(":#{Capybara.server_port}", "")
  end
end

World(SubdomainMethods)