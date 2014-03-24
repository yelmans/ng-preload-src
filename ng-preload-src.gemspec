# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ng/preload/src/package'

Gem::Specification.new do |spec|
  spec.name          = Ng::Preload::Src::NAME
  spec.version       = Ng::Preload::Src::VERSION
  spec.authors       = [Ng::Preload::Src::AUTHOR["name"]]
  spec.email         = [Ng::Preload::Src::AUTHOR["email"]]
  spec.summary       = Ng::Preload::Src::DESCRIPTION
  spec.description   = Ng::Preload::Src::LONGDESCRIPTION
  spec.homepage      = Ng::Preload::Src::HOMEPAGE
  spec.license       = Ng::Preload::Src::LICENSE["type"]

  spec.files         = ["package.json", "LICENSE", "README.md"] + Dir["lib/**/*.rb"] + Dir["vendor/assets/javascripts/*.js"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  
  spec.add_runtime_dependency "railties", ">= 3.1"
end
