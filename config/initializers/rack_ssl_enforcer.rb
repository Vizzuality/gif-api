if ENV['RAILS_ENV'] == 'production'
  Rails::Application.config.middleware.insert_before ActionDispatch::Cookies, Rack::SslEnforcer, :only => /^\/admin\//
end