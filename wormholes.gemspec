# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wormholes/version'

Gem::Specification.new do |gem|
  gem.name          = "wormholes"
  gem.version       = Wormholes::VERSION
  gem.authors       = ["Aaron Royer"]
  gem.email         = ["aaronroyer@gmail.com"]
  gem.description   = %q{shell utility that warps text elsewhere}
  gem.summary       = "Pipe text (like log output) in one end and output it anywhere else."
  gem.homepage      = "https://github.com/aaronroyer/wormholes"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
