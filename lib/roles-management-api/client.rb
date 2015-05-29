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

      if response.code != "200"
        puts "Error querying RM, response code was #{response.code}."
        return false
      end

      return true
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

      if response.code != "200"
        puts "Error querying RM, response code was #{response.code}."
        return nil
      end

      return Role.new(role_id, response)
    end

    # Returns a Person object for the given loginid or nil on error / not found
    def find_person_by_id(id)
      response = get_request("people/" + id.to_s + ".json")

      if response.code != "200"
        puts "Error querying RM, response code was #{response.code}."
        return nil
      end

      return Person.new(response)
    end

    # Returns a Person object for the given loginid or nil on error / not found
    def find_person_by_loginid(loginid)
      response = get_request("people/" + loginid + ".json")

      if response.code != "200"
        puts "Error querying RM, response code was #{response.code}."
        return nil
      end

      return Person.new(response)
    end

    private

      # Performs a HTTP GET using the configured API endpoint and key
      def get_request(url)
        request = Net::HTTP::Get.new(@uri.request_uri + "/" + url)
        request = sign_request(request)

        return @conn.request(request)
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
