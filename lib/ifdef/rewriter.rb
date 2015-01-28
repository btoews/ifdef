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
        replace(_else.loc.expression, "nil")
      when false
        replace(_then.loc.expression, "nil")
      end
    end
  end
end
