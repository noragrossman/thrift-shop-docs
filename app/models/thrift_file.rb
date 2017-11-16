class ThriftFile
  attr_reader :name, :namespaces, :includes, :enums, :typedefs, :structs, :constants, :services

  def self.included(base)
    base.send :extend, ClassMethods
  end

  def initialize(name:, enums:, typedefs:, structs:, constants:, services:)
    @name = name
    @enums = enums
    @typedefs = typedefs
    @structs = structs
    @constants = constants
    @services = services
  end

  class << self
    def from_json(json)
      # Deal with services
      services = []
      services_json = json['services']
      services_json.each do |s|
        services.push(ThriftService.from_json(s))
      end

      new(
        name: json['name'],
        enums: json['enums'],
        typedefs: json['typedefs'],
        structs: json['structs'],
        constants: json['constants'],
        services: services,
      )
    end
  end

end
