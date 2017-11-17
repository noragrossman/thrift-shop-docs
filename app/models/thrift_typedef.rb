# TODO you should probably merge this with ThriftType
class ThriftTypedef
  attr_reader :name, :type_id, :comment

  def initialize(name:, type_id:)
    @name = name
    @type_id = type_id
  end

  def add_comment(comment)
    @comment = comment
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        type_id: json['typeId'],
      )
    end

    # 'string', 'Email', '\n'
    def from_token_array(tokens)
      type_id, name = tokens

      new(
        name: name,
        type_id: type_id,
      )
    end
  end
end
