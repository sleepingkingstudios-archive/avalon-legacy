class CreatePendragonSkills < ActiveRecord::Migration
  def self.up
    create_table :pendragon_skills do |t|
      t.string :name
      t.string :type
      t.string :subtypes
      
      t.string :cost
      t.string :range
      t.string :target
      t.string :trigger
      
      t.text :description
      t.string :description_format, :default => "plain"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pendragon_skills
  end
end
