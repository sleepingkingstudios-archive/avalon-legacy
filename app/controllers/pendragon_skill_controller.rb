class PendragonSkillController < ApplicationController
  def list
    @skills = PendragonSkill.all
  end # method list
  
  def edit
    @skill = skill_from_id_or_slug params[:id]
  end # method edit
  
  def show
    @skill = skill_from_id_or_slug params[:id]
  end # method show
  
  def skill_from_id_or_slug(param)
    if param.match /^\d*$/
      # parameter is an integer, so probably an id
      skill = PendragonSkill.find param
    else
      # parameter is not an integer, so hopefully a slug
      skill = PendragonSkill.find_by_slug param
    end # if-else
    return skill
  rescue ActiveRecord::RecordNotFound => err
    return nil
  end # method skill_from_id_or_slug
  private :skill_from_id_or_slug
end # end controller PendragonSkillController
