module Searchkon
  module RegexFormatter
  SIMPLE_RANGE_FORMAT_REGEX = /\((.*)\.\.(.*)\)/
  RELATIONAL_FORMAT_REGEX = /(.*)\.(.*)/
  DIGIT_RANGE_FORMAT_REGEX = /\((\d*)\.\.(\d*)\)/
  DATE_RANGE_FORMAT_REGEX = /\((\d{4}-\d{1,2}-\d{1,2})\.\.(\d{4}-\d{1,2}-\d{1,2})\)/

  def relational? value
    value.to_s.match RELATIONAL_FORMAT_REGEX
  end

  def range? value
    value.to_s.match SIMPLE_RANGE_FORMAT_REGEX
  end

  def date_range? value
    value.to_s.match DATE_RANGE_FORMAT_REGEX
  end

  def digit_range? value
    value.to_s.match DIGIT_RANGE_FORMAT_REGEX
  end

  def range_values value
    struct = Struct.new :from, :to
    regex_match value, SIMPLE_RANGE_FORMAT_REGEX, struct
  end

  def relation_values value
    struct = Struct.new :relation, :key
    regex_match value, RELATIONAL_FORMAT_REGEX, struct
  end

  private

    def regex_match value, pattern, struct
      value.to_s.match(pattern) { |m| struct.new(*m.captures) }
    end
  end
end
