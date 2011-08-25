class PendragonSkillController < ApplicationController
  def list
    @skills = PendragonSkill.all
  end # method list
  
  def show
    if params[:id].match /^\d*$/
      # params is an id
      @skill = PendragonSkill.find params[:id]
    else
      @skill = PendragonSkill.find_by_slug params[:id]
    end # if-else
  end # method show
end # end controller PendragonSkillController
