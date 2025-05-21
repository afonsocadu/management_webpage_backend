source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'
gem 'factory_bot_rails'
gem 'rspec-rails', '~> 5.0'

gem 'rails', '~> 6.1.7', '>= 6.1.7.6'
gem 'sqlite3', '~> 1.4'
gem 'puma', '~> 5.0'
gem 'rack-cors'
gem 'roo'
gem 'sidekiq'
gem 'foreman'

gem 'bootsnap', '>= 1.4.4', require: false

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development do
  gem 'listen', '~> 3.3'
  gem 'spring'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

group :production do
  gem 'sass-rails', '~> 6'
  gem 'sprockets-rails', '~> 3.2'
end

gem "active_model_serializers", "~> 0.10.14"
