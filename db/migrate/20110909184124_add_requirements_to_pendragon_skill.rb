class AddRequirementsToPendragonSkill < ActiveRecord::Migration
  def self.up
    add_column :pendragon_skills, :requirements, :text
  end

  def self.down
    remove_column :pendragon_skills, :requirements
  end
end
