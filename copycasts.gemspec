Gem::Specification.new do |s|
  s.name        = "copycasts"
  s.version     = "0.0.1"
  s.authors     = ["Nicholas Ng"]
  s.email       = ["secret@live.com.my"]
  s.homepage    = ""
  s.summary     = %q{CopyCat}
  s.description = %q{Stealing videos}
  
  s.add_development_dependency "nokogiri", "~> 1.5", ">= 1.5.6"
  s.add_development_dependency "open-uri", "~> 1.5", ">= 1.5.6"
  s.files = [
    "lib/copycasts.rb"
  ]
  s.require_paths = ["lib"]
end