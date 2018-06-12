module RolesManagementAPI
  class Role
    attr_accessor :id, :application_id, :description, :name, :token, :assignments, :members

    # Creates a new Role object from a NET/HTTP response (see client.rb)
    def initialize(role_id, json)
      @id = role_id
      @application_id = json[:application_id]
      @description = json[:description]
      @name = json[:name]
      @token = json[:token]

      @assignments = RoleAssignmentArray.new(role_id)
      json[:role_assignments_attributes].each do |assignment_json|
        @assignments << RoleAssignment.new(assignment_json)
      end

      @members = []
      json[:members].each do |member|
        @members << Person.new(member)
      end
    end

    def as_json
      {
        role: {
          role_assignments_attributes: @assignments.as_json
        }
      }
    end
  end

  # RoleAssignmentArray is an array-like class used by Role for maintaining its
  # assignment list. Its primary purpose is to add the Rails-required "_destroy: true"
  # attribute in its as_json for any assignment which has been removed.
  class RoleAssignmentArray
    def initialize(role_id)
      @assignments = []
      @role_id = role_id
    end

    def <<(assignment)
      raise "You may only add objects of type 'RoleAssignment' or 'Person'" unless assignment.is_a?(RoleAssignment) or assignment.is_a?(Person)

      if assignment.is_a?(Person)
        @assignments << RoleAssignment.new({entity_id: assignment.id, role_id: @role_id})
      else
        @assignments << assignment
      end
    end

    def [](idx)
      @assignments[idx]
    end

    def each &block
      @assignments.each &block
    end

    def length
      @assignments.length
    end

    def delete(member)
      raise "You may only delete objects of type 'RoleAssignment'" unless member.is_a?(RoleAssignment)

      @assignments.each do |assignment|
        if (assignment.id == member.id) && (member.id != nil)
          assignment.destroy = true
          return true
        end
      end

      return false
    end

    def as_json
      @assignments.map{ |a| a.as_json }
    end
  end
end
