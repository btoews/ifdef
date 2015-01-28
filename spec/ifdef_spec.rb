require "ifdef"

describe Ifdef, ".parse" do
  subject { Ifdef }

  it "parses ruby" do
    expect(subject.parse("nil")).to be_a(AST::Node)
  end
end
