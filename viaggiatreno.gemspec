lib = File.expand_path('lib', __dir__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'viaggiatreno/version'

Gem::Specification.new do |gem|
  gem.name          = 'viaggiatreno'
  gem.version       = Viaggiatreno::VERSION
  gem.authors       = ['Michele Bologna']
  gem.email         = ['michele.bologna@gmail.com']
  gem.description   = 'A web scraper to fetch real time information
                      on train riding the Italian railway system
                      (viaggiatreno/trenitalia)'
  gem.summary       = 'A scraper for real time information on Italian
                      railway system (viaggiatreno)'
  gem.homepage      = 'https://www.github.com/mbologna/viaggiatreno'
  gem.license       = 'MIT'

  gem.files         = Dir.chdir(File.expand_path('.', __dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'mechanize'
  gem.add_dependency 'nokogiri'
  gem.add_development_dependency 'rake'
end
