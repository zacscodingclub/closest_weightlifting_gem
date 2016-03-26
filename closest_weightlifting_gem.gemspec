# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'closest_weightlifting_gem/version'

Gem::Specification.new do |spec|
  spec.name          = "closest_weightlifting_gem"
  spec.version       = ClosestWeightliftingGem::VERSION
  spec.authors       = ["zacscodingclub"]
  spec.email         = ["zbaston@gmail.com"]

  spec.summary       = "USA Weighlifting Club Gyms"
  spec.description   = "This gem uses the data available on the USA Weightlifting website (http://www.teamusa.org/usa-weightlifting/clubs-lwc/find-a-club) to create a simple CLI interface with all the gyms."
  spec.homepage      = "http://rubygems.org/gems/closest_weightlifting_gem"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10.3"

  spec.add_dependency "nokogiri", "~> 1.6.7.2"
  spec.add_dependency "require_all", "~> 1.3.3"
  spec.add_dependency "titleize", "~> 1.4.0"
end
