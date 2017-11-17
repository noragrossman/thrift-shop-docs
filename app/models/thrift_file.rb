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

      # This variable stores any comment that may come before an element
      comment = nil

      while tokens.count > 0
        t = tokens.shift

        case t
        when 'struct', 'union', 'exception'
          # Find the end paren and use that chunk to make a struct
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
        when '//'
          # This is a comment until the end of the line
          line_break_index = tokens.index('\n')
          comment_array = tokens.shift(line_break_index)
          new_comment = comment_array.join(' ')
          puts "Found a struct comment: #{new_comment}"
          if comment
            comment += ' ' + new_comment
          else
            comment = new_comment
          end
        else
        end
      end

      new(
        structs: structs,
      )
    end

  end

end
