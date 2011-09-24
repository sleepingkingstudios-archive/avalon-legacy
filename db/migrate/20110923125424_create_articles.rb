class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :slug
      t.text :contents
      t.integer :category_id
      t.boolean :is_published

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
