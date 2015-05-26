module RolesManagementAPI
  class Client
    attr_accessor :url, :username, :api_key
    @conn = nil
    @uri = nil

    def initialize(url, username, api_key)
      @uri = URI.parse(url)

      @conn = Net::HTTP.new(@uri.host, @uri.port)
      @conn.use_ssl = true

      @username = username
      @api_key = api_key
    end

    def connected?
      response = get_request("validate")

      if response.code != "200"
        puts "Error querying RM, response code was #{response.code}."
        return false
      end

      return true
    end

    def find_role_by_id(role_id)
      response = get_request("roles/" + role_id.to_s + ".json")

      if response.code != "200"
        puts "Error querying RM, response code was #{response.code}."
        return nil
      end

      return Role.new(role_id, response)
    end

    private

    def get_request(url)
      request = Net::HTTP::Get.new(@uri.request_uri + "/" + url)

      # RM requires we specify which version of the API we want
      request.add_field("Accept", "application/vnd.roles-management.v1")
      # RM requires we provide the username and API key via HTTP Basic Auth
      request.basic_auth(@username, @api_key)

      return @conn.request(request)
    end
  end
end
