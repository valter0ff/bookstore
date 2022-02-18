# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'bootsnap', '>= 1.4.4', require: false
gem 'haml', '~> 5.2.2'
gem 'haml-rails', '~> 2.0.1'
gem 'jbuilder', '~> 2.7'
gem 'pagy', '~> 5.10.1'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4', '>= 6.1.4.6'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'fasterer', '~> 0.9.0', require: false
  gem 'ffaker', '~> 2.20'
  gem 'i18n-tasks', '~> 0.9.37'
  gem 'pry-byebug', '~> 3.9.0'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 5.1.0'
  gem 'rubocop-performance', '~> 1.13.2', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'brakeman', '~> 5.2.1'
  gem 'bullet', '~> 7.0.1'
  gem 'bundle-audit', '~> 0.1.0'
  gem 'database_consistency', '~> 1.1.12', require: false
  gem 'lefthook', '~> 0.7.7'
  gem 'listen', '~> 3.7.1'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring', '~> 4.0.0'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'capybara-screenshot', '~> 1.0.26'
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec_junit_formatter', '~> 0.5.1'
  gem 'selenium-webdriver', '~> 4.1.0'
  gem 'shoulda-matchers', '~> 5.1.0'
  gem 'site_prism', '~> 3.7.3'
  gem 'webdrivers', '~> 5.0.0'
end
