# TODO Come back and fill this in
class ThriftConstant
  attr_reader :name, :type_id, :type, :value, :comment

  def initialize(name:, type_id:, :type, :value)
    @name = name
    @type_id = type_id
    @type = type
    @value = value
  end

  def add_comment(comment)
    @comment = comment
  end

  class << self
    # 'const', 'i32', 'BOOK_LIMIT', '=', '500'
    def from_token_array(tokens)
      name = nil
      type_id = nil
      type = nil
      value = nil

      new(
        name: name,
        type_id: type_id,
        type: type,
        value: value,
      )
    end
  end
end
