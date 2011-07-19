require "haml"

class PendragonSkill < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name, :type, :description
  validates_inclusion_of :description_format, :in => %w(plain html redcarpet)
  
  self.inheritance_column = :inheritance_type
  
  def <=>(other)
    self.name <=> other.name
  end # method <=>
  
  def subtypes_as_array
    return self.subtypes.split(/,\ |,|\ /)
  end # method subtypes_as_array
  
  def subtypes_as_formatted_string
    return (self.subtypes_as_array.map do |string| string.capitalize end).join(", ")
  end # method subtypes_as_formatted_string
  
  def slug(str = "_")
    return self.name.downcase.split().join(str)
  end # method slug
end # end class PendragonSkill
