class ThriftFunction
  # TODO: move this
  THRIFT_BASE_TYPES = %w(bool byte i16 i32 i64 double binary string)

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
      # ["Book",     "get_book(", "\\n", "1:", "string", "name", ",", "\\n", ")", "throws", "(", "\\n", "1:", "BookNotFoundException", "book_not_found", ",", "\\n", ")"]
      name = nil
      return_type_id = nil
      return_type = nil
      oneway = false
      arguments = []
      exceptions = []

      # Return type name is the first token
      return_type_name = tokens.shift
      # Check for base types, else create new type
      if THRIFT_BASE_TYPES.include?(return_type_name)
        # Is the type_name one of the base types?
        return_type_id = return_type_name
      elsif /\w+<\w+>/.match(return_type_name)
        # list<Petition>
        return_type = ThriftContainer.from_string(return_type_name)
      else
        # We know it is a custom struct or custom type
        return_type_id = 'struct'
        # TODO: Deal with custom types (typedef)
        # TODO make type
        return_type = ThriftType.from_string(return_type_id, return_type_name)
      end

      # Next token is the function name + open paren
      name_token = tokens.shift
      name = name_token.slice(0, name_token.length - 1)

      # Keep track of comments
      comment = nil

      # Are we iterating through arguments or exceptions?
      adding_exceptions = false

      # Find the arguments
      while tokens.count > 0
        t = tokens.shift

        case t
        when '\n', ')'
          # Discard
        when /\d+:/
          # The sentinel value is the next comma
          index_next_comma = tokens.index(',')
          field_tokens = tokens.shift(index_next_comma)
          # Add the key back
          field_tokens.unshift(t)

          # Create the field
          field = ThriftField.from_token_array(field_tokens)

          # Discard the comma
          tokens.shift

          # Add any associated comment
          if comment
            field.add_comment(comment)
            comment = nil
          end

          # Add to list of fields
          if (adding_exceptions)
            exceptions.push(field)
          else
            arguments.push(field)
          end
        when '//'
          # comment
        when '('
          # exceptions
          adding_exceptions = true
        else
          'bad'
        end
      end

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
