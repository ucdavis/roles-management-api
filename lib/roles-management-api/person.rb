module RolesManagementAPI
  class Person
    attr_accessor :id, :loginid, :name

    # Creates a new Person object from a JSON object
    def initialize(json)
      self.id = json[:id]
      self.loginid = json[:loginid]
      self.name = json[:name]
    end
  end
end
