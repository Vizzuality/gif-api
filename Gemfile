source 'http://rubygems.org'

ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'
gem 'pg', '~> 0.18'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'devise', '4.2.0'
gem 'activeadmin', github: 'activeadmin/activeadmin'
gem 'kaminari', github: "amatsuda/kaminari", branch: '0-17-stable'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'
gem 'active_model_serializers', '0.10.5'
gem 'active_admin_theme', '1.0.2'
gem 'activeadmin_addons'
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '4.3.6'
gem 'awesome_print', '1.6.1'
gem 'dotenv-rails', '2.0.1'
gem 'rack-cors', require: 'rack/cors'
gem 'roo'
gem 'faker'
gem 'friendly_id', '~> 5.1.0'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_girl_rails', '4.8.0'
end

group :development do
  gem 'puma', '~> 3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'better_errors', '2.1.1'
  gem 'binding_of_caller', '0.7.2'
  gem 'web-console', '>= 3.3.0'
  gem 'annotate', '2.7.1'

  # Deploy
  gem 'capistrano'
  gem 'capistrano-env-config'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano-passenger'
end

group :test do
  gem 'rspec-rails', '3.5.0'
  gem 'database_cleaner', '1.5.3'
end
