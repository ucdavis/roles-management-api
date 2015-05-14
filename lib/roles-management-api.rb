require "roles-management-api/version"
require "roles-management-api/client"

require "json"
require "net/http"
require "uri"

module RolesManagementAPI
  # Creates an instance of the RolesManagementAPIClient upon successful login
  # or returns false.
  def RolesManagementAPI.login(url, username, api_key)
    client = RolesManagementAPI::Client.new(url, username, api_key)

    if client.connected?
      return client
    else
      return false
    end
  end
end
