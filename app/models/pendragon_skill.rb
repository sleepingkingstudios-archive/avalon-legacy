require "haml"

class PendragonSkill < ActiveRecord::Base
  validates_uniqueness_of :id, :name, :slug
  validates_presence_of :name, :type, :description
  validates_inclusion_of :description_format, :in => %w(plain html redcarpet)
  
  self.inheritance_column = :inheritance_type
  
  def update_attributes(attributes)
    attributes[:slug] = convert_name_to_slug attributes[:name]
    
    super attributes
  end # method update_attributes
  
  def <=>(other)
    self.name <=> other.name
  end # method <=>
  
  def subtypes_as_array
    return (self.subtypes || []).split(/,\ |,|\ /)
  end # method subtypes_as_array
  
  def subtypes_as_formatted_string
    return (self.subtypes_as_array.map do |string| string.capitalize end).join(", ")
  end # method subtypes_as_formatted_string
  
  def to_slug(char = '-')
    return convert_name_to_slug self.name, char
  end # method to_slug
  
  def convert_name_to_slug(name, char = '-')
    return name.downcase.split().join(char)
  end # method convert_name_to_slug
  private :convert_name_to_slug
end # end class PendragonSkill
