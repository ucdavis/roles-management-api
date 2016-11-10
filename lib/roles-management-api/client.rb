module RolesManagementAPI
  @@client = nil

  class Client
    attr_accessor :url, :username, :api_key

    @conn = nil
    @uri = nil

    def initialize(url, username, api_key)
      @uri = URI.parse(url)

      @conn = Net::HTTP.new(@uri.host, @uri.port)
      @conn.use_ssl = true if @uri.scheme == "https"

      @username = username
      @api_key = api_key
    end

    # Returns true if the API endpoint and key are valid and can connect
    def connected?
      response = get_request("validate")

      return response.code == "200"
    end

    def save(object)
      if object.is_a? RolesManagementAPI::Role
        response = put_request("roles/" + object.id.to_s + ".json", object.as_json)
        return response
      else
        STDERR.puts "Cannot save object: type '#{object.class}' not supported."
        return false
      end
    end

    # Returns a Role object for the given role_id or nil on error / not found
    def find_role_by_id(role_id)
      response = get_request("roles/" + role_id.to_s + ".json")

      return nil unless response.code == "200"

      json = JSON.parse(response.body, symbolize_names: true)

      return Role.new(role_id, json)
    end

    # Returns a Person object for the given loginid or nil on error / not found
    def find_entity_by_id(id)
      response = get_request("entities/" + id.to_s + ".json")

      return nil unless response.code == "200"

      json = JSON.parse(response.body, symbolize_names: true)

      if json[:type] == "Person"
        return Person.new(json)
      else
        STDERR.puts "Did not understand entity type returned by RM."
        return nil
      end
    end

    # Returns a Person object for the given loginid or nil on error / not found
    def find_person_by_loginid(loginid)
      response = get_request("people/" + loginid + ".json")

      return nil unless response.code == "200"

      json = JSON.parse(response.body, symbolize_names: true)

      return Person.new(json)
    end

    private

      # Performs a HTTP GET using the configured API endpoint and key
      def get_request(url)
        request_url = @uri.request_uri + "/" + url
        request = Net::HTTP::Get.new(request_url)
        request = sign_request(request)

        response = @conn.request(request)

        STDERR.puts "Error querying RM, response code was #{response.code} for URL #{request_url}." unless response.code == "200"

        return response
      end

      # Performs a HTTP POST using the configured API endpoint and key
      def put_request(url, data)
        request = Net::HTTP::Put.new(@uri.request_uri + "/" + url, initheader = {'Content-Type' =>'application/json'})
        request = sign_request(request)

        request.body = data.to_json

        return @conn.request(request)
      end

      # Adds the necessary HTTP headers and API key to a request
      def sign_request(request)
        # RM requires we specify which version of the API we want
        request.add_field("Accept", "application/vnd.roles-management.v1")
        # RM requires we provide the username and API key via HTTP Basic Auth
        request.basic_auth(@username, @api_key)

        return request
      end

  end
end
