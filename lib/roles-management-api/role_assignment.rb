module RolesManagementAPI
  class RoleAssignment
    attr_accessor :id, :entity_id, :role_id, :destroy

    # Creates a new Person object from a JSON object
    def initialize(json)
      @id = json[:id]
      @entity_id = json[:entity_id]
      @role_id = json[:role_id]
      @destroy = false
    end

    def as_json
      json = {}
      json['_destroy'] = true if @destroy

      json.merge({
        id: @id,
        entity_id: @entity_id,
        role_id: @role_id
      })
    end
  end
end
