
class ThriftEnumMember
  attr_reader :name, :value, :comment

  def initialize(name:, value:)
    @name = name
    @value = value
  end

  def add_comment(comment)
    @comment = comment
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        value: json['value'],
      )
    end

    def from_token_array(tokens)
      # ["SCIFI", "=", "1"]
      if tokens.count != 3
        'bad'
      end

      name, _, value = tokens

      new(
        name: name,
        value: value,
      )
    end
  end
end
