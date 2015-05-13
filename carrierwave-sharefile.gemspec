# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave/sharefile/version'

Gem::Specification.new do |spec|
  spec.name          = "carrierwave-sharefile"
  spec.version       = Carrierwave::Sharefile::VERSION
  spec.authors       = ["Matthew McFarling"]
  spec.email         = ["matt@codemancode.com"]
  spec.summary       = %q{Sharefile integration for Carrierwave.}
  spec.description   = %q{Carrierwave storage for sharefile.}
  spec.homepage      = "http://www.codemancode.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "carrierwave"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
