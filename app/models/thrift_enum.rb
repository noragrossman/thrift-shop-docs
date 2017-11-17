class ThriftEnum
  attr_reader :name, :members

  def initialize(name:, members:)
    @name = name
    @members = members
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        members: json['members'].map { |m| ThriftEnumMember.from_json(m) },
      )
    end
  end
end
