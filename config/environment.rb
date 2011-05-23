# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Avalon::Application.initialize!

# Configure Sass
Sass::Plugin.options[:cache] = false