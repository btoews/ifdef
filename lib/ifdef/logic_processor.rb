module Ifdef
  class LogicProcessor < Parser::AST::Processor
    class LogicError < StandardError; end

    def initialize(truth)
      @truth = truth
    end

    # Evaluate a logical statement and reduce it to true/false if we know
    # enough to do so.
    #
    # ast - the AST to evaluate.
    #
    # Returns true if we know the statement to be :true, :false if we know the
    # statement to be false, and nil otherwise.
    def result(ast)
      case @truth.fetch(ast, process(ast))
      when :true
        :true
      when :false
        :false
      else
        nil
      end
    end

    # Handle the `||` statement.
    #
    # node - the node to evaluate.
    #
    # Returns :true if either side is known to be true, :false if both sides are
    # known to be false, and nil otherwise.
    def on_or(node)
      a, b = node.children.map { |c| @truth.fetch(c, process(c)) }

      if a == :true || b == :true
        :true
      elsif a == :false && b == :false
        :false
      else
        nil
      end
    end

    # Handle the `&&` statement.
    #
    # node - the node to evaluate.
    #
    # Returns :true if both sides are known to be true, :false if either sides
    # is known to be false, and nil otherwise.
    def on_and(node)
      a, b = node.children.map { |c| @truth.fetch(c, process(c)) }

      if a == :true && b == :true
        :true
      elsif a == :false || b == :false
        :false
      else
        nil
      end
    end

    # Handles the `!` statement.
    #
    #
    # node - the node to evaluate.
    #
    # Returns the inverse of the child expression.
    def on_send(node)
      _target, _method, _args = node.children

      if _method == :!
        case @truth.fetch(_target, process(_target))
        when :true
          :false
        when :false
          :true
        else
          nil
        end
      else
        nil
      end
    end

    # Handle logic statements explicitly wrapped in parenthesis.
    #
    # node - the node to evaluate.
    #
    # Returns the result of the statement within the parenthesis.
    def on_begin(node)
      child, other_children = *node.children

      # Not sure if this can happen in an `if` statement
      raise LogicError if other_children

      case @truth.fetch(child, process(child))
      when :true
        :true
      when :false
        :false
      else
        nil
      end
    end

    # Handle the `true` statement.
    #
    # node - the node to evaluate.
    #
    # Returns :true
    def on_true(node)
      :true
    end

    # Handle the `false` statement.
    #
    # node - the node to evaluate.
    #
    # Returns :false
    def on_false(node)
      :false
    end

    # Handle the `nil` statement.
    #
    # node - the node to evaluate.
    #
    # Returns :false
    def on_nil(node)
      :false
    end

    def node?(object)
      object.is_a?(Parser::AST::Node)
    end
  end
end
