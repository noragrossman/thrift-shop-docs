class ThriftContainer
  # TODO: move this
  THRIFT_BASE_TYPES = %w(bool byte i16 i32 i64 double binary string)

  attr_reader :type_id, :elem_type_id, :elem_type, :comment

  def initialize(type_id:, elem_type_id:, elem_type:)
    @type_id = type_id
    @elem_type_id = elem_type_id
    @elem_type = elem_type
  end

  def add_comment(comment)
    @comment = comment
  end

  class << self
    def from_json(json)
      new(
        type_id: json['typeId'],
        elem_type_id: json['elemTypeId'],
        elem_type: ThriftType.from_json(json['elemType']),
      )
    end

    def from_string(s)
      /(?<container>\w+)<(?<type_name>\w+)>/ =~ s
      type_id = container
      if THRIFT_BASE_TYPES.include?(type_name)
        elem_type_id = type_name
        elem_type = nil
      else
        elem_type_id = 'struct'
        # TODO: Deal with custom types (typedef)
        # TODO make type
        elem_type = ThriftType.from_string(elem_type_id, type_name)
      end

      new(
        type_id: type_id,
        elem_type_id: elem_type_id,
        elem_type: elem_type,
      )
    end
  end
end
