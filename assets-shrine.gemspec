require_relative 'lib/assets_shrine/version'

Gem::Specification.new do |spec|
  spec.name          = "assets-shrine"
  spec.version       = AssetsShrine::VERSION
  spec.authors       = ['']
  spec.email         = ['']

  spec.summary       = %q{Shrine adapter to interact with assets service}
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "http", ">= 4.0"
  spec.add_dependency "connection_pool"
  spec.add_dependency "down", "~> 5.0"
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency "pry"
end
