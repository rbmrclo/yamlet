# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yamlet/version'

Gem::Specification.new do |spec|
  spec.name          = "yamlet"
  spec.version       = Yamlet::VERSION
  spec.authors       = ["Robbie Marcelo"]
  spec.email         = ["rbmrclo@hotmail.com"]
  spec.licenses      = ['MIT']

  spec.summary       = %q{Inject CRUD functionalities to your Plain Old Ruby Objects and store data in a YAML file}
  spec.description   = %q{A small library which injects CRUD functionalities to your Plain Old Ruby Objects and store data in a YAML file}
  spec.homepage      = "https://github.com/rbmrclo/yamlet"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '~> 3.0'
end
