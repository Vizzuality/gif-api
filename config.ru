# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require "rack/secure_cookies"

use Rack::SecureCookies
use CookieMiddleware
run Rails.application
