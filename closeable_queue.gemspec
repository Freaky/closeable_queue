# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'closeable_queue/version'

Gem::Specification.new do |spec|
  spec.name          = "closeable_queue"
  spec.version       = CloseableQueue::VERSION
  spec.authors       = ["Thomas Hurst"]
  spec.email         = ["tom@hur.st"]

  spec.summary       = %q{Thread-safe queues with safer shutdown semantics}
  spec.description   = %q{Adds a #close method to the standard library Queue and SizedQueue to close down consumers}
  spec.homepage      = "https://github.com/Freaky/closeable_queue"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_dependency "concurrent-ruby"
end
