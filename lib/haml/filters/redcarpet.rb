# lib/haml/filters/redcarpet.rb
require 'redcarpet'

module Haml::Filters::Redcarpet
  include Haml::Filters::Base
  
  def render(text)
    markdown = Redcarpet.new(text)
    return markdown.to_html
  end # method render
end # module Haml::Filters::Redcarpet