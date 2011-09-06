class AddActionToPendragonSkills < ActiveRecord::Migration
  def self.up
    add_column :pendragon_skills, :action, :string
  end

  def self.down
    remove_column :pendragon_skills, :action
  end
end
