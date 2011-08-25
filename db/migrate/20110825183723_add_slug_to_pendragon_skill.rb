class AddSlugToPendragonSkill < ActiveRecord::Migration
  def self.up
    add_column :pendragon_skills, :slug, :string
    
    PendragonSkill.all.each do |skill|
      skill.slug = skill.name.downcase.split().join('-')
      skill.save
    end # each
  end

  def self.down
    remove_column :pendragon_skills, :slug
  end
end
