class ThriftFile
  attr_reader :name, :namespaces, :includes, :enums, :typedefs, :structs, :constants, :services

  def self.included(base)
    base.send :extend, ClassMethods
  end

  def initialize(name: nil, enums: nil, typedefs: nil, structs: nil, constants: nil, services: nil)
    @name = name
    @enums = enums
    @typedefs = typedefs
    @structs = structs
    @constants = constants
    @services = services
  end

  def to_s
    file_string = @name
    # Add typedefs
    @typedefs.each do |t|
      file_string += "#{t.to_s}\n"
    end

    # Add enums
    @enum.each do |e|
      file_string += "#{e.to_s}\n"
    end

    # Add structs
    @structs.each do |s|
      file_string += "#{s.to_s}\n"
    end

    # Add services
    @services.each do |s|
      file_string += "#{s.to_s}\n"
    end
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        enums: json['enums'], # TODO
        typedefs: json['typedefs'], #TODO
        structs: json['structs'].map { |s| ThriftStruct.from_json(s) },
        constants: json['constants'], # TODO
        services: json['services'].map { |s| ThriftService.from_json(s) },
      )
    end

    # %i[struct Book { 1: string author , 2: i32 num_pages , }]
    def from_token_array(tokens)
      structs = []
      services = []
      enums = []
      typedefs = []

      # This variable stores any comment that may come before an element
      comment = nil

      while tokens.count > 0
        t = tokens.shift

        case t
        when 'typedef'
          # This is a typedef until the end of the line
          line_break_index = tokens.index('\n')
          typedef_array = tokens.shift(line_break_index)

          puts "Found a typedef: #{typedef_array}"

          # Make the typedef
          typedef = ThriftTypedef.from_token_array(typedef_array)

          # Add any comment
          if comment
            typedef.add_comment(comment)
            comment = nil
          end

          # Add to the list of typedefs
          typedefs.push(typedef)
        when 'enum'
          # Use the next close bracket as the sentinel value
          last_token_index = tokens.index('}')
          enum_tokens = tokens.shift(last_token_index + 1)

          puts "Found an enum: #{enum_tokens}"

          enum = ThriftEnum.from_token_array(enum_tokens)

          # Add any comment that may have been given, THIS SHOULD GO ON ALL COMMENTABLE TYPES
          if comment
            enum.add_comment(comment)
            comment = nil
          end

          enums.push(enum)
        when 'struct', 'union', 'exception'
          # Use the next close bracket as the sentinel value
          last_token_index = tokens.index('}')
          struct_tokens = tokens.shift(last_token_index + 1)
          # put the type back on there
          struct_tokens.unshift(t)
          puts "Found a struct: #{struct_tokens}"

          struct = ThriftStruct.from_token_array(struct_tokens)

          # Add any comment that may have been given, THIS SHOULD GO ON ALL COMMENTABLE TYPES
          if comment
            struct.add_comment(comment)
            comment = nil
          end

          structs.push(struct)
        when 'service'
          # Use the next close bracket as the sentinel value
          last_token_index = tokens.index('}')
          service_tokens = tokens.shift(last_token_index + 1)
          puts "Found a service: #{service_tokens}"

          service = ThriftService.from_token_array(service_tokens)

          # Add any comment that may have been given, THIS SHOULD GO ON ALL COMMENTABLE TYPES
          if comment
            service.add_comment(comment)
            comment = nil
          end

          services.push(service)
        when '//'
          # This is a comment until the end of the line
          line_break_index = tokens.index('\n')
          comment_array = tokens.shift(line_break_index)
          new_comment = comment_array.join(' ')
          if comment
            comment += ' ' + new_comment
          else
            comment = new_comment
          end
        else
          # Discard
        end
      end

      new(
        enums: enums,
        structs: structs,
        services: services,
        typedefs: typedefs,
      )
    end
  end
end
