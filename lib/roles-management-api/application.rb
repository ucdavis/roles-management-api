module RolesManagementAPI
  class Application
    attr_accessor :id, :name, :url, :description

    # Creates a new Application object from a NET/HTTP response (see client.rb)
    def initialize(application_id, json)
      @id = application_id
      @name = json[:name]
      @url = json[:url]
      @description = json[:description]
    end

    def as_json
      json = {}

      json.merge({
        id: @id,
        name: @name,
        url: @url,
        description: @description
      })
    end
  end
end
