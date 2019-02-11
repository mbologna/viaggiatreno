source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

group :development do
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false
end

group :test do
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end
