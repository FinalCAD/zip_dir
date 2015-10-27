# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zip_dir/version'

Gem::Specification.new do |spec|
  spec.name          = "zip_dir"
  spec.version       = ZipDir::VERSION
  spec.authors       = ["Steve Chung"]
  spec.email         = ["hello@stevenchung.ca"]

  spec.summary       = "Zip and unzip directories."
  spec.homepage      = "https://github.com/FinalCAD/zip_dir"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rubyzip", '>= 1.0.0'
end
