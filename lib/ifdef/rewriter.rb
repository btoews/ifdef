module Ifdef
  class Rewriter < ::Parser::Rewriter
    def initialize(truth)
      @truth = truth
      super()
    end

    def on_if(node)
      _if, _then, _else = *node.children
      case @truth[_if]
      when true
        process(_then) if _then
        replace(_else.loc.expression, "nil") if _else
      when false
        process(_else) if _else
        replace(_then.loc.expression, "nil") if _then
      else
        process(_then) if _then
        process(_else) if _else
      end
    end
  end
end
