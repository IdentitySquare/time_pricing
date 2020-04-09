lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "time_pricing/version"

Gem::Specification.new do |spec|
  spec.name          = "time_pricing"
  spec.version       = TimePricing::VERSION
  spec.authors       = ["Anna Joe", "Daniel Paul"]
  spec.email         = ["57370408+Annajoe96@users.noreply.github.com", "im@danielpaul.me"]

  spec.summary       = "TimePricing"
  spec.description   = "A gem to calcualte pricing for a time based service, bookings or appointments."
  spec.homepage      = "https://identitysquare.github.io/time_pricing/"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/IdentitySquare/time_pricing"
  spec.metadata["changelog_uri"] = "https://github.com/IdentitySquare/time_pricing/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.14"
  spec.add_development_dependency "activesupport"
end
