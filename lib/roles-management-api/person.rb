module RolesManagementAPI
  class Person
    attr_accessor :id, :loginid, :name

    # Creates a new Person object from a JSON object
    def initialize(response)
      json = JSON.parse(response.body, symbolize_names: true)

      @id = json[:id]
      @loginid = json[:loginid]
      @name = json[:name]
    end

    def as_json
      json = {}

      json.merge({
        id: @id,
        loginid: @loginid,
        name: @name
      })
    end
  end
end
