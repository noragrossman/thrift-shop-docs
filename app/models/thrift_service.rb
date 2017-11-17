class ThriftService
  attr_reader :name, :functions, :comment

  def initialize(name:, functions:)
    @name = name
    @functions = functions
  end

  def add_comment(comment)
    @comment = comment
  end

  class << self
    def from_json(json)
      new(
        name: json['name'],
        functions: json['functions'].map { |f| ThriftFunction.from_json(f) },
      )
    end

    def from_token_array(tokens)
      # ["LibraryService", "{", "\\n", "Author", "get_author(", "\\n", "1:", "Book", "book", ",", "\\n", ")", ",", "\\n", "}"]
      name = tokens.shift
      functions = []

      # Discard off the open bracket
      tokens.shift

      # Find the functions

      # Keep track of comments
      comment = nil

      while tokens.count > 0
        t = tokens.shift

        case t
        when '\n', '}'
          # discard
        when '//'
          # This is a comment until the end of the line
          line_break_index = tokens.index('\n')
          comment_array = tokens.shift(line_break_index)
          new_comment = comment_array.join(' ')
          puts "Found a service comment: #{new_comment}"
          if comment
            comment += ' ' + new_comment
          else
            comment = new_comment
          end
        else
          # Sentinel value is close paren
          last_token_index = tokens.index(')')
          function_tokens = tokens.shift(last_token_index + 1)
          # Put the return type back
          function_tokens.unshift(t)

          # Check for 'throws' keyword
          if tokens.first == 'throws'
            # TODO this is the same as above, so DRY this up
            # Pull out the exception portion
            # Sentinel value is close paren
            last_token_index = tokens.index(')')
            exception_tokens = tokens.shift(last_token_index + 1)
            # Put the return type back
            exception_tokens.unshift(t)

            # Add exception to function
            function_tokens += exception_tokens
          end

          puts "Found a function: #{function_tokens}"

          # Create the new function and add it to the service
          function = ThriftFunction.from_token_array(function_tokens)

          # Add any associated comment
          if comment
            function.add_comment(comment)
            comment = nil
          end

          # Discard the comma
          tokens.shift

          functions.push(function)
        end
      end

      new(
        name: name,
        functions: functions,
      )
    end
  end
end
