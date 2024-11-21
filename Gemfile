source 'https://rubygems.org'
ruby "2.7.8"

gem 'rails', '7.0.4'
gem 'pg'
gem 'sass-rails', '~> 6.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 5.0.0'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.11'
gem 'sdoc', '~> 2.0.3', group: :doc

gem 'rack-cors', '~> 1.1'

gem 'sidekiq', '~> 7.0'
gem 'redis', '~> 5.0'
gem 'sinatra', '~> 2.1', :require => nil

gem 'virtus', '~> 1.0', '>= 1.0.4'
gem 'sidekiq-failures'

gem 'foreman', '~> 0.87'

group :development, :test do
  gem 'byebug'
  gem 'listen'
  gem 'rspec-rails', '~> 4.0'
  gem 'spring'
  gem 'web-console', '~> 4.1'
end

group :production do
  gem 'puma'
  gem 'rails_12factor', '~> 0.0', '>= 0.0.3'
end

gem "pry", "= 0.15.0", :groups => [:development, :test]

gem "rubocop", "= 1.68", :groups => [:development, :test]
