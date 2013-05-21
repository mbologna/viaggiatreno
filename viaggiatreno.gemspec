# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'viaggiatreno/version'

Gem::Specification.new do |gem|
  gem.name          = "viaggiatreno"
  gem.version       = Viaggiatreno::VERSION
  gem.authors       = ["Michele Bologna"]
  gem.email         = ["michele.bologna@gmail.com"]
  gem.description   = %q{A web scraper to fetch real time information on train riding the Italian railway system (viaggiatreno/trenitalia)}
  gem.summary       = %q{A scraper for real time information on Italian railway system (viaggiatreno)}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "nokogiri"
end
