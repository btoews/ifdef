require "ifdef"

describe Ifdef::Rewriter, "#process" do
  def run_example(name)
    example_dir = File.expand_path(File.join(__FILE__, "../../data/", name))

    # What we're expecting the rewriter to output.
    expected_output = File.read(File.join(example_dir, "output.rb"))

    # The truth to assert on the example source.
    truth = Ifdef::Truth.load_json(File.join(example_dir, "truth.json"))

    # The source code to operate on.
    source_path = File.join(example_dir, "source.rb")
    source = File.read(source_path)
    ast    = Ifdef.parse(source)
    buffer = Parser::Source::Buffer.new(source_path)
    buffer.source = source

    # Rewrite the source.
    rewriter = Ifdef::Rewriter.new(truth)
    actual_output = rewriter.rewrite(buffer, ast)
    expect(actual_output).to eq(expected_output)
  end

  it "replaces else branch in if statement with nil" do
    run_example("if_statement")
  end

  it "replaces then branch in unless statement with nil" do
    run_example("unless_statement")
  end
end
