# coding: utf-8
$:.unshift File.expand_path('../lib', __FILE__)
require 'ifdef/version'

Gem::Specification.new do |spec|
  spec.name        = "ifdef"
  spec.version     = Ifdef::VERSION
  spec.authors     = ["Ben Toews"]
  spec.email       = ["mastahyeti@gmail.com"]
  spec.homepage    = "https://github.com/mastahyeti/ifdef"
  spec.summary     = "Ruby rewriter to replace false logic branches"
  spec.description = "Parse source code, looking for conditional statements and replace brances that are known to be false."
  spec.licenses    = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["ifdef"]
  spec.require_paths = ["lib"]

  spec.add_dependency "parser", "~> 2.2"

  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "bundler", "~> 1.6"
end
