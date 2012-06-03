module Jekyll
  module Filters
    # Convert text to JSON string.
    #
    # "ab\"c" -> "\"ab\\\"c\""
    def json(input)
      require 'json'
      input.to_json
    end
  end
end