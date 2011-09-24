class Article < ActiveRecord::Base
  validate :title, :slug, :presence => true
  
  belongs_to :category
  
  def path
    if self.category.is_a? Category
      return self.category.path + "/" + self.slug
    else
      return self.slug
    end # if-else
  end # method path
end # model Article
