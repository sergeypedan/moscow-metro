# frozen_string_literal: true

require_relative 'lib/moscow_metro/version'

Gem::Specification.new do |spec|
  spec.author      =  "Sergey Pedan"
  spec.summary     =  "Database of lines and stations metro & metro-like train transport of Moscow"
  spec.description =  "#{spec.summary}. Can be used as a database alongside a real database or as a source of data for further import into your database."
  spec.email       = ["sergey.pedan@gmail.com"]
  spec.homepage    =  "https://github.com/sergeypedan/moscow-metro"
  spec.license     =  "MIT"
  spec.name        =  "moscow_metro"
  spec.version     =   MoscowMetro::VERSION

  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata = {
    changelog_uri:     "#{spec.homepage}/blob/master/Changelog.md",
    documentation_uri: "#{spec.homepage}#usage",
    homepage_uri:      spec.homepage,
    source_code_uri:   spec.homepage
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^#{spec.bindir}/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
