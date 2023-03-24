# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/autoupload/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-autoupload"
  spec.version       = Guard::AutouploadVersion::VERSION
  spec.authors       = ["Jyrki Lilja"]
  spec.email         = ["jyrki.lilja@focus.fi"]
  spec.summary       = %q{Autoupload plugin - uploads local changes to remote host.}
  spec.description   = %q{Uses either SFTP or FTP.}
  spec.homepage      = "https://github.com/jyrkij/guard-autoupload"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'guard', '>= 2'
  spec.add_runtime_dependency 'net-sftp', '>= 4.0'
  spec.add_runtime_dependency 'net-scp', '>= 4.0'

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", ">= 13"
end
