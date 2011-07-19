require 'rubygems'
gem 'haml'

class Articles::Pendragon::Skill
  attr_accessor :name, :type, :subtypes, :description
  attr_accessor :cost, :range, :target, :trigger
  
  def to_haml
    
  end # method to_haml
  
  def to_html
    haml_engine = Haml::
  end # method to_html
end # class Articles::Pendragon::Skill