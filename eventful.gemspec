# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "eventful/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "eventful"
  spec.version     = Eventful::VERSION
  spec.authors     = ["Andrew Ek"]
  spec.email       = ["andrewek@gmail.com"]
  spec.homepage    = "https://github.com/andrewek/eventful"
  spec.summary     = "Generate events from user activity"
  spec.description = "It's not quite event-driven development, but representing state changes as events in the system can help us to better understand system activity."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "readme.markdown"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.2"

  spec.add_development_dependency "pg"
  spec.add_development_dependency "annotate"
end
