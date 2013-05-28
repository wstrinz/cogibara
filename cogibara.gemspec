# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cogibara/version'

Gem::Specification.new do |spec|
  spec.name          = "cogibara"
  spec.version       = Cogibara::VERSION
  spec.authors       = ["wstrinz"]
  spec.email         = ["wstrinz@gmail.com"]
  spec.description   = %q{Modular, extensible personal assistant}
  spec.summary       = %q{Modular, extensible personal assistant}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'speech2text'

  spec.add_dependency 'maluuba_napi2'
  spec.add_dependency 'json', "~> 1.7.7"
  spec.add_dependency "cleverbot2"
  spec.add_dependency 'bing_translator'
  spec.add_dependency 'wikipedia-client'
  spec.add_dependency 'sanitize'
  spec.add_dependency 'uuid'
  spec.add_dependency 'redis'
  spec.add_dependency 'wikicloth'
  spec.add_dependency 'wolfram'
  spec.add_dependency 'google_calendar'
  spec.add_dependency 'forecast_io'
  spec.add_dependency 'geocoder'
  spec.add_dependency 'slop'
end
