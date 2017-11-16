class ThriftService
  attr_reader :name, :functions

  def initialize(name:, functions:)
    @name = name
    @functions = functions
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        functions: json['functions'],
      )
    end
  end
end
