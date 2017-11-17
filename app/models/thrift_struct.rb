class ThriftStruct
  attr_reader :name, :is_exception, :is_union, :fields, :comment

  def initialize(name:, is_exception:, is_union:, fields:)
    @name = name
    @is_exception = is_exception
    @is_union = is_union
    @fields = fields
  end

  def add_comment(comment)
    @comment = comment
  end

  def to_s
    struct_type = if is_exception
      'exception'
    elsif is_union
      'union'
    else
      'struct'
    end

    struct_string = "#{struct_type} #{name} {"
    @fields.each do |f|
      struct_string += "  #{f.to_s},\n"
    end
    struct_string += '}\n'
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        is_exception: json['is_exception'],
        is_union: json['is_union'],
        fields: json['fields'].map { |f| ThriftField.from_json(f) },
      )
    end

    # %i[struct Book \n { \n \\ A person 1: string author , \n 2: i32 num_pages , \n }]
    def from_token_array(tokens)
      # Pull out the name and type of struct
      type_of_struct, name = tokens.shift(2)

      # Determine if exception, union, or vanilla struct
      is_exception, is_union = false
      case type_of_struct
      when 'exception'
        is_exception = true
      when 'union'
        is_union = true
      end

      # Find the fields
      fields = []

      # Keep track of comments
      comment = nil

      while tokens.count > 0
        t = tokens.shift

        case t
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
          fields.push(field)
        when '//'
          # This is a comment until the end of the line
          line_break_index = tokens.index('\n')
          comment_array = tokens.shift(line_break_index)
          new_comment = comment_array.join(' ')
          puts "Found a field comment: #{new_comment}"
          if comment
            comment += ' ' + new_comment
          else
            comment = new_comment
          end
        else
          'bad'
        end
      end

      new(
        name: name,
        is_exception: is_exception,
        is_union: is_union,
        fields: fields,
      )
    end
  end
end
