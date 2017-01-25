# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/auth/travis_webhook/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-auth-travis-webhook'
  spec.version       = Rack::Auth::TravisWebhook::VERSION
  spec.authors       = ['Nikhil Benesch']
  spec.email         = ['nikhil.benesch@gmail.com']

  spec.summary       = 'Rack middleware to verify Travis CI webhook requests.'
  spec.homepage      = 'https://github.com/benesch/rack-auth-travis-webhook'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'vcr', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 2.1'
end
