module RolesManagementAPI
  class GroupRule
    attr_accessor :id, :column, :condition, :value, :destroy

    # Creates a new GroupRule object from a JSON object
    def initialize(json = {})
      @id = json[:id] || nil
      @column = json[:column] || nil
      @condition = json[:condition] || nil
      @value = json[:value] || nil
      @destroy = false
    end

    def as_json
      json = {}
      json['_destroy'] = true if @destroy

      json.merge({
        id: @id,
        column: @column,
        condition: @condition,
        value: @value
      })
    end
  end
end
