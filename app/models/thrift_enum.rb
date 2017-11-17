class ThriftEnum
  attr_reader :name, :members, :comment

  def initialize(name:, members:)
    @name = name
    @members = members
  end

  def add_comment(comment)
    @comment = comment
  end

  def to_s
    enum_string = "enum #{name} {" + '\n'
    @members.each do |m|
      enum_string += "  " + m.to_s + ","
    end
    enum_string += "}"
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        members: json['members'].map { |m| ThriftEnumMember.from_json(m) },
      )
    end

    def from_token_array(tokens)
      # ["Category", "{", "\\n", "//", "This", "could", "be", "literally", "anything", "\\n", "NONFICTION", "=", "0", ",", "\\n", "SCIFI", "=", "1", ",", "\\n", "FANTASY", "=", "2", ",", "\\n", "MYSTERY", "=", "3", ",", "\\n", "}"]
      name = nil
      members = []

      # Name is the first token
      name = tokens.shift

      # Find the members
      # Keep track of comments
      comment = nil

      while tokens.count > 0
        t = tokens.shift

        case t
        when '\n', '{', '}'
          # Discard
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
          # The sentinel value is the next comma
          index_next_comma = tokens.index(',')
          member_tokens = tokens.shift(index_next_comma)
          # Add the first token back
          member_tokens.unshift(t)

          # Create the enum member
          member = ThriftEnumMember.from_token_array(member_tokens)

          # Discard the comma
          tokens.shift

          # Add any associated comment
          if comment
            member.add_comment(comment)
            comment = nil
          end

          # Add to the list of members
          members.push(member)
        end
      end

      new(
        name: name,
        members: members,
      )
    end
  end
end
