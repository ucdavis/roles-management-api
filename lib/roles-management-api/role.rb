module RolesManagementAPI
  class Role
    attr_accessor :id, :application_id, :description, :name, :token, :members

    # Creates a new Role object from a NET/HTTP response (see client.rb)
    def initialize(role_id, response)
      json = JSON.parse(response.body, symbolize_names: true)

      self.id = role_id
      self.application_id = json[:application_id]
      self.description = json[:description]
      self.name = json[:name]
      self.token = json[:token]

      self.members = RoleMemberList.new
      json[:members].each do |json_member|
        self.members << Person.new(json_member)
      end
    end

    def save!

    end
  end

  # RoleMemberList is an array of Person objects but allows you to
  # automatically create a Person object if you simply append a
  # login ID, e.g. RoleMemberList << "loginid" will be the same as
  # RoleMemberList << Person.new({loginid: "loginid", ...})
  class RoleMemberList < Array
    def <<(member)
      if member.is_a? Person
        super(member)
      else
        # Assume it's a login ID string
        super(Person.new({id: nil, loginid: member, name: nil}))
      end
    end
  end
end
