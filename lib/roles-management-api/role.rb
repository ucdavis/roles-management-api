module RolesManagementAPI
  class Role
    attr_accessor :id, :application_id, :description, :name, :token, :members

    # Creates a new Role object from a NET/HTTP response (see client.rb)
    def initialize(role_id, response)
      json = JSON.parse(response.body, symbolize_names: true)

      @id = role_id
      @application_id = json[:application_id]
      @description = json[:description]
      @name = json[:name]
      @token = json[:token]

      @members = []
      json[:members].each do |json_member|
        @members << Person.new(json_member)
      end
    end

    def as_json
      {
        application_id: @application_id,
        description: @description,
        name: @name,
        token: @token,
        members: @members.map{ |m| m.as_json }
      }
    end
  end
end
