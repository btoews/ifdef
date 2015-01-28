require "ifdef"

describe Ifdef::LogicProcessor, "#result" do
  include AST::Sexp

  subject do
    Ifdef::LogicProcessor.new(
      Ifdef.parse("true_statement") => :true,
      Ifdef.parse("false_statement") => :false,
    )
  end

  def result(statement)
    subject.result(Ifdef.parse(statement))
  end

  it "handles basic statements" do
    expect(result("true_statement")).to eq(:true)
    expect(result("false_statement")).to eq(:false)
  end

  it "follows basic logic for &&" do
    expect(result("true && true")).to eq(:true)
    expect(result("true && false")).to eq(:false)
    expect(result("false && true")).to eq(:false)
    expect(result("false && false")).to eq(:false)

    expect(result("true_statement && true")).to eq(:true)
    expect(result("true_statement && false")).to eq(:false)
    expect(result("false_statement && true")).to eq(:false)
    expect(result("false_statement && false")).to eq(:false)

    expect(result("true && true_statement")).to eq(:true)
    expect(result("true && false_statement")).to eq(:false)
    expect(result("false && true_statement")).to eq(:false)
    expect(result("false && false_statement")).to eq(:false)

    expect(result("true_statement && true_statement")).to eq(:true)
    expect(result("true_statement && false_statement")).to eq(:false)
    expect(result("false_statement && true_statement")).to eq(:false)
    expect(result("false_statement && false_statement")).to eq(:false)
  end

  it "follows basic logic for ||" do
    expect(result("true || true")).to eq(:true)
    expect(result("true || false")).to eq(:true)
    expect(result("false || true")).to eq(:true)
    expect(result("false || false")).to eq(:false)

    expect(result("true_statement || true")).to eq(:true)
    expect(result("true_statement || false")).to eq(:true)
    expect(result("false_statement || true")).to eq(:true)
    expect(result("false_statement || false")).to eq(:false)

    expect(result("true || true_statement")).to eq(:true)
    expect(result("true || false_statement")).to eq(:true)
    expect(result("false || true_statement")).to eq(:true)
    expect(result("false || false_statement")).to eq(:false)

    expect(result("true_statement || true_statement")).to eq(:true)
    expect(result("true_statement || false_statement")).to eq(:true)
    expect(result("false_statement || true_statement")).to eq(:true)
    expect(result("false_statement || false_statement")).to eq(:false)
  end

  it "follows basic logic for !" do
    expect(result("!true")).to eq(:false)
    expect(result("!false")).to eq(:true)

    expect(result("!true_statement")).to eq(:false)
    expect(result("!false_statement")).to eq(:true)
  end

  it "chains logic for implicitly nested statements" do
    expect(result("true && true && true")).to eq(:true)
    expect(result("true && true && false")).to eq(:false)

    expect(result("true || true || true")).to eq(:true)
    expect(result("true || false || true")).to eq(:true)
  end

  it "chains logic for explicitly nested statements" do
    expect(result("true || (true || true)")).to eq(:true)
    expect(result("true && (true || true)")).to eq(:true)
    expect(result("true || (true && true)")).to eq(:true)
    expect(result("true && (true && true)")).to eq(:true)

    expect(result("false || (true || true)")).to eq(:true)
    expect(result("false && (true || true)")).to eq(:false)
    expect(result("false || (true && true)")).to eq(:true)
    expect(result("false && (true && true)")).to eq(:false)

    expect(result("true || (false || true)")).to eq(:true)
    expect(result("true && (false || true)")).to eq(:true)
    expect(result("true || (false && true)")).to eq(:true)
    expect(result("true && (false && true)")).to eq(:false)

    expect(result("true || (true || false)")).to eq(:true)
    expect(result("true && (true || false)")).to eq(:true)
    expect(result("true || (true && false)")).to eq(:true)
    expect(result("true && (true && false)")).to eq(:false)

    expect(result("false || (false || true)")).to eq(:true)
    expect(result("false && (false || true)")).to eq(:false)
    expect(result("false || (false && true)")).to eq(:false)
    expect(result("false && (false && true)")).to eq(:false)

    expect(result("true || (false || false)")).to eq(:true)
    expect(result("true && (false || false)")).to eq(:false)
    expect(result("true || (false && false)")).to eq(:true)
    expect(result("true && (false && false)")).to eq(:false)

    expect(result("false || (false || false)")).to eq(:false)
    expect(result("false && (false || false)")).to eq(:false)
    expect(result("false || (false && false)")).to eq(:false)
    expect(result("false && (false && false)")).to eq(:false)
  end
end
