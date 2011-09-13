require "haml"

class PendragonSkill < ActiveRecord::Base
  validates_uniqueness_of :id, :name, :slug
  validates_presence_of :name, :type, :description
  validates_inclusion_of :description_format, :in => %w(plain html redcarpet)
  
  self.inheritance_column = :inheritance_type
  
  def self.convert_name_to_slug(name, char = '-')
    return name.downcase.split().join(char)
  end # class method convert_name_to_slug
  
  def <=>(other)
    self.name <=> other.name
  end # method <=>
  
  def subtypes_as_array
    return (self.subtypes || "").split(",").map do |subtype| subtype.strip end
  end # method subtypes_as_array
  
  def subtypes_as_formatted_string
    ary = self.subtypes_as_array
    if ary.empty? then return "" end
    ary = ary.map do |string|
      string = (string.split(" ").map do |substring|
        (substring.split("/").map do |subsubstring|
          subsubstring.capitalize 
        end).join("/")
      end).join(" ")
    end # map
    return "[#{ary.join(", ")}]"
  end # method subtypes_as_formatted_string
  
  def to_slug(char = '-')
    return self.class.convert_name_to_slug self.name, char
  end # method to_slug
end # end class PendragonSkill
