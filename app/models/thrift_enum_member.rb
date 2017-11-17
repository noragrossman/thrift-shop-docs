
class ThriftEnumMember
  attr_reader :name, :value

  def initialize(name:, value:)
    @name = name
    @value = value
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        value: json['value'],
      )
    end
  end
end
