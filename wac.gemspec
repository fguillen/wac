require_relative 'lib/wac/version'

Gem::Specification.new do |spec|
  spec.name          = "wac"
  spec.version       = Wac::VERSION
  spec.authors       = ["Fernando Guillen"]
  spec.email         = ["fguillen.mail@gmail.com"]

  spec.summary       = "Ruby tool to extract Wikipedia's article elements and convert for an easy use"
  spec.description   = "Ruby tool to extract Wikipedia's article elements and convert for an easy use"
  spec.homepage      = "https://github.com/fguillen/wac"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fguillen/wac"
  spec.metadata["changelog_uri"] = "https://github.com/fguillen/wac/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "vcr", "~> 5.1.0"
  spec.add_development_dependency "webmock", "~> 3.8.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 12.0"
end
