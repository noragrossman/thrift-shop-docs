class ThriftField
  # TODO: move this
  THRIFT_BASE_TYPES = %w(bool byte i16 i32 i64 double binary string)

  attr_reader :key, :name, :type_id, :type, :required, :comment

  def initialize(key:, name:, type_id:, type:, required:)
    @key = key
    @name = name
    @type_id = type_id
    @type = type
    @required = required || 'default'
  end

  def add_comment(comment)
    @comment = comment
  end

  def to_s
    "#{key}: #{required != 'default' ? required : ''} #{type ? type.to_s : type_id} #{name}"
  end

  class << self
    def from_json(json)
      new(
        key: json['key'],
        name: json['name'],
        type_id: json['typeId'],
        type: ThriftType.from_json(json['type']),
        required: json['required'],
      )
    end

    # %i[1: string author]
    def from_token_array(tokens)
      if tokens.count == 3
        key, type_name, name = tokens
        required = nil
      else
        # A requiredness value is specified
        key, required, type_name, name = tokens
      end

      # Remove the : from the key and convert to int
      key = key.gsub(/:/, '').to_i

      if THRIFT_BASE_TYPES.include?(type_name)
        # Is the type_name one of the base types?
        type_id = type_name
        type = nil
      elsif /\w+<\w+>/.match(type_name)
        # list<Petition>
        type = ThriftContainer.from_string(type_name)
      else
        # We know it is a custom struct or custom type
        type_id = 'struct'
        # TODO: Deal with custom types (typedef)
        # TODO make type
        type = ThriftType.from_string(type_id, type_name)
      end

      new(
        key: key,
        name: name,
        type_id: type_id,
        type: type,
        required: required,
      )
    end
  end
end
