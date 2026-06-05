source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.6"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem "rails", "~> 7.2.0"

gem "rails-i18n", "~> 7.0"

gem "ajax-datatables-rails", "~> 1.5.0"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.6"
# Use Puma as the app server
gem "puma", "~> 6.4"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "shakapacker", "~> 8.0"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [ :mri, :mingw, :x64_mingw ]
  # Ruby style + formatting (Rails' default omakase rules)
  gem "rubocop-rails-omakase", require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

group :production do
  gem "pg"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [ :mingw, :mswin, :x64_mingw, :jruby ]

gem "annotate", "~> 3.1"

gem "devise"

gem "faraday", "~> 2.12"

gem "faraday-retry", "~> 2.2"

gem "devise-i18n", "~> 1.9"

gem "lograge", "~> 0.14"

gem "bootstrap_form", "~> 4.5"

gem "paper_trail", "~> 15.2"

gem "prawn-rails", "~> 1.4"
