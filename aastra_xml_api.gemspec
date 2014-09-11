# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aastra_xml_api/version'

Gem::Specification.new do |spec|
  spec.name          = "aastra_xml_api"
  spec.version       = AastraXmlApi::VERSION
  spec.authors       = ["Emery A. Miller"]
  spec.email         = ["emery.miller@easyofficephone.com"]
  spec.description   = %q{Gemified version of Carlton O'Riley's Aastra XML Ruby Port}
  spec.summary       = %q{Aastra XML API for Ruby}
  spec.homepage      = "https://github.com/EasyOfficePhone/aastra_xml_api"
  spec.license       = "GNU GPL v2"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
end
