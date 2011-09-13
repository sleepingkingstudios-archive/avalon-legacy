class AddResistToSkills < ActiveRecord::Migration
  def self.up
    add_column :pendragon_skills, :resist, :string
  end

  def self.down
    remove_column :pendragon_skills, :resist
  end
end
