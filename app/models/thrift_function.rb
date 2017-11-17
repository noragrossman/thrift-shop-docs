class ThriftFunction
  attr_reader :name, :return_type_id, :return_type, :oneway, :arguments, :exceptions, :comment

  def initialize(name:, return_type_id:, return_type:, oneway:, arguments:, exceptions:)
    @name = name
    @return_type_id = return_type_id
    @return_type = return_type
    @oneway = oneway
    @arguments = arguments
    @exceptions = exceptions
  end

  def add_comment(comment)
    @comment = comment
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        return_type_id: json['returnTypeId'],
        return_type: ThriftType.from_json(json['returnType']),
        oneway: json['oneway'],
        arguments: json['arguments'].map { |a| ThriftField.from_json(a) },
        exceptions: json['exceptions'].map { |e| ThriftStruct.from_json(e) },
      )
    end

    def from_token_array(tokens)
      # ["Author", "get_author(", "\\n", "1:", "Book", "book", ",", "\\n", ")"]
      name = nil
      return_type_id = nil
      return_type = nil
      oneway = false
      arguments = []
      exceptions = []

      new(
        name: name,
        return_type_id: return_type_id,
        return_type: return_type,
        oneway: oneway,
        arguments: arguments,
        exceptions: exceptions,
      )
    end
  end
end
