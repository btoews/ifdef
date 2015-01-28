require "ifdef"

describe Ifdef::Truth, "#load_json" do
  subject { Ifdef::Truth }

  it "loads json files" do
    path = File.expand_path("../../data/truth.json", __FILE__)
    expect(subject.load_json(path)).to be_a(Hash)
  end
end

describe Ifdef::Truth, "#parse_hash" do
  subject { Ifdef::Truth }

  it "returns a hash whose values are :true/:false" do
    hash = {
      "true" => ["true_statement"]
    }
    subject.parse_hash(hash).values.each do |value|
      expect(value).to eq(:true).or(:false)
    end
  end

  it "returns a hash whose keys are nodes" do
    hash = {
      "true" => ["true_statement"]
    }
    subject.parse_hash(hash).keys.each do |key|
      expect(key).to be_a(Parser::AST::Node)
    end
  end

  it "allows strings or arrays as input hash values" do
    with_string = subject.parse_hash("true" => "true_statement")
    with_array  = subject.parse_hash("true" => ["true_statement"])
    expect(with_array).to eq(with_string)
  end
end
