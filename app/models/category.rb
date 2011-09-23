class Category < ActiveRecord::Base
  validate :title, :slug, :presence => :true
  
  belongs_to :parent, :class_name => "Category"
  has_many :children, :class_name => "Category", :foreign_key => "parent_id"
  
  def path
    if self.parent.is_a? Category
      return self.parent.path + "/" + self.slug
    else
      return self.slug
    end # if-else
  end # method path
end # model Category
