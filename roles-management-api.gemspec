# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roles-management-api/version'

Gem::Specification.new do |spec|
  spec.name          = "roles-management-api"
  spec.version       = RolesManagementAPI::VERSION
  spec.authors       = ["Christopher Thielen"]
  spec.email         = ["cmthielen@ucdavis.edu"]

  spec.summary       = %q{Ruby gem for consuming the DSS IT Roles Management API}
  spec.description   = %q{Ruby gem for consuming the RESTful JSON-based DSS IT Roles Management API.}
  spec.homepage      = "https://github.com/dssit/roles-management-api"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 12.3"
end
