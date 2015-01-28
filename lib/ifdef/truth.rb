module Ifdef
  module Truth
    # Loads and parseds a truth-hash from a JSON file.
    #
    # path - The path of the JSON file.
    #
    # Returns a Hash.
    def load_json(path)
      parse_hash(JSON.parse(File.read(path)))
    end

    BOOLEAN_MAPPING = {"true" => true, "false" => false}.freeze

    # Convert a Hash like:
    #
    #   { true => ["statement1", "statement2"], false => "statement3"}
    #
    # to a Hash like:
    #
    #   {
    #     s(:send, nil, :statement1) => true,
    #     s(:send, nil, :statement2) => true,
    #     s(:send, nil, :statement3) => false
    #   }
    #
    # hash - The Hash to convert.
    #
    # Returns a new Hash.
    def parse_hash(hash)
      hash.each_with_object({}) do |(key, values), new_hash|
        Array(values).each do |value|
          new_hash[Ifdef.parse(value)] = BOOLEAN_MAPPING[key]
        end
      end
    end

    extend self
  end
end
