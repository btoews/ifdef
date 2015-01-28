require "parser/current"
require "json"
require "ifdef/rewriter"
require "ifdef/logic_processor"
require "ifdef/truth"

module Ifdef
  def parse(src)
    Parser::CurrentRuby.parse(src)
  end

  extend self
end
