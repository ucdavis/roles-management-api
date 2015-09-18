module RolesManagementAPI
  class Person
    attr_accessor :id, :loginid, :name, :role_assignments, :group_memberships

    # Creates a new Person object from a JSON object
    def initialize(json)
      @id = json[:id]
      @loginid = json[:loginid]
      @name = json[:name]
      @role_assignments = json[:role_assignments]
      @group_memberships = json[:group_memberships]
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
