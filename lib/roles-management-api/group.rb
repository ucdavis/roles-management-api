module RolesManagementAPI
  class Group
    attr_accessor :id, :name, :members, :rules

    # Creates a new Group object from a JSON object
    def initialize(json)
      @id = json[:id]
      @name = json[:name]
      @members = json[:members]

      @rules = GroupRuleArray.new(@id)
      json[:rules].each do |rule_json|
        @rules << GroupRule.new(rule_json)
      end
    end

    def as_json
      json = {}

      json.merge({
        id: @id,
        name: @name,
        rules_attributes: @rules.as_json
      })
    end
  end

  # GroupRuleArray is an array-like class used by Group for maintaining its
  # rule list. Its primary purpose is to add the Rails-required "_destroy: true"
  # attribute in its as_json for any rule which has been removed.
  class GroupRuleArray
    def initialize(group_id)
      @rules = []
      @group_id = group_id
    end

    def <<(rule)
      raise "You may only add objects of type 'GroupRule'" unless rule.is_a?(GroupRule)

      @rules << rule
    end

    def [](idx)
      @rules[idx]
    end

    def each &block
      @rules.each &block
    end

    def length
      @rules.length
    end

    def delete(rule)
      raise "You may only delete objects of type 'GroupRule'" unless rule.is_a?(GroupRule)

      @rules.each do |r|
        if (r.id == rule.id) && (rule.id != nil)
          r.destroy = true
          return true
        end
      end

      return false
    end

    def as_json
      @rules.map{ |r| r.as_json }
    end
  end
end
