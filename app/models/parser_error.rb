class ParserError < StandardError
  def initialize(msg)
    super(msg)
  end
end