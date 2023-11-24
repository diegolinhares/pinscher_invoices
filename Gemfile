# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.2.2'

# Essential
gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.2'
gem 'redis', '>= 4.0.1'
gem 'tzinfo-data', platforms: %i[windows jruby]

# Front-end and assets
gem 'cssbundling-rails'
gem 'importmap-rails'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

# Application
gem 'u-case', '~> 4.5.1'

group :development, :test do
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'fuubar'
  gem 'lefthook'
  gem 'rspec-rails', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'web-console'
end

group :test do
  gem 'shoulda-matchers', require: false
  gem 'simplecov', require: false
end
