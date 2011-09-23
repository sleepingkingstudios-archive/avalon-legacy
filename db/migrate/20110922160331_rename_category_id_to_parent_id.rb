class RenameCategoryIdToParentId < ActiveRecord::Migration
  def self.up
    change_table :categories do |t|
      t.rename :category_id, :parent_id
    end # change_table
  end # method up

  def self.down
    change_table :categories do |t|
      t.rename :parent_id, :category_id
    end # change_table
  end # method down
end # migration RenameCategoryIdToParentId
