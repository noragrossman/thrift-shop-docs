class ThriftType
  attr_reader :type_id, :type_name

  def initialize(type_id:, type_name:)
    @type_id = type_id
    @type_name = type_name
  end

  def to_s
    type_name
  end

  class << self
    def from_json(json)
      new(
        type_id: json['typeId'],
        type_name: json['class'],
      )
    end

    # 'struct', 'Author'
    def from_string(type_id, s)
      # TODO Add more logic for typedefs
      new(
        type_id: type_id,
        type_name: s,
      )
    end
  end
end
