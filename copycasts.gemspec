# -*- encoding: utf-8 -*-
require File.expand_path('../lib/copycasts/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "copycasts"
  spec.version       = Copycasts::VERSION
  spec.authors       = ["Nicholas"]
  spec.email         = ["secret@live.com.my"]
  spec.description   = %q{Offline watch free episode of railscast videos for personal usage.}
  spec.summary       = %q{Download videos from video source}
  spec.homepage      = "https://github.com/nichthinkof30/copycasts"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["copycasts-start-crawl"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "nokogiri", "~> 1.5", ">= 1.5.6"
  spec.add_development_dependency "open-uri", "~> 1.5", ">= 1.5.6"
end
