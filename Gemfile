# frozen_string_literal: true

source 'https://rubygems.org'

ruby File.read('.ruby-version').strip

# Traincontrol dependencies
gem 'concurrent-ruby'
gem 'uart'

# Rails
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'

# Assets & front-end
gem 'cssbundling-rails'
gem 'jsbundling-rails'
gem 'propshaft'
gem 'stimulus-rails'
gem 'turbo-rails'

# Environment
gem 'bootsnap', require: false
gem 'puma'
gem 'sqlite3', '~> 1.4'
# gem 'redis', '>= 4.0.1'
# gem 'kredis'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem 'image_processing', '~> 1.2'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'
end
