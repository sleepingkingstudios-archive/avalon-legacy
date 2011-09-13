class Articles::Pendragon::SkillsController < ApplicationController
  before_filter :authenticate, :only => [:edit, :new, :update]
  
  # GET /articles/pendragon/skills/:id
  # GET /articles/pendragon/skills/:slug
  def show
    @skill = skill_from_id_or_slug params[:id]
    if @skill.nil?
      flash[:error].push "Unknown skill #{params[:id]}"
      redirect_to "/articles/pendragon/skills/list"
    end # if
  end # action show
  
  # GET /articles/pendragon/skills/list
  def list
    @skills = PendragonSkill.all.sort_by(&:name)
  end # action list
  
  # GET /articles/pendragon/skills/new
  def new
    @skill = PendragonSkill.new
  end # action new
  
  # POST /articles/pendragon/skills
  def create
    # concatenate the skill subtypes
    subtypes = (params[:subtype] || []).select do |subtype| !(subtype.nil? || subtype.empty?) end
    subtypes = subtypes.map do |subtype| subtype.downcase end
    params[:pendragon_skill][:subtypes] = subtypes.sort().join(",")
    params[:pendragon_skill][:slug] = PendragonSkill.convert_name_to_slug params[:pendragon_skill][:name], "-"
    
    @skill = PendragonSkill.new(params[:pendragon_skill])
    
    if @skill.save
      redirect_to [:articles, @skill], :notice => "Skill was successfully created."
    else
      render :action => "new"
    end # if-else
  end # action create
  
  # GET /articles/pendragon/skills/:id/edit
  # GET /articles/pendragon/skills/:slug/edit
  def edit
    @skill = skill_from_id_or_slug params[:id]
  end # action edit
  
  # PUT /articles/pendragon/skills/:id
  # PUT /articles/pendragon/skills/:slug
  def update
    @skill = skill_from_id_or_slug params[:id]
    
    # concatenate the skill subtypes
    subtypes = (params[:subtype] || []).select do |subtype| !(subtype.nil? || subtype.empty?) end
    subtypes = subtypes.map do |subtype| subtype.downcase end
    params[:pendragon_skill][:subtypes] = subtypes.sort().join(",")
    params[:pendragon_skill][:slug] = PendragonSkill.convert_name_to_slug params[:pendragon_skill][:name], "-"
    
    if @skill.update_attributes(params[:pendragon_skill])
      # successful update
      logger.debug "#{self}: Successfully updated skill.\n#{@skill.inspect}"
      redirect_to articles_pendragon_skill_path, :notice => 'Skill was successfully updated.'
    else
      # unsuccessful update
      render :action => "edit"
    end # if-else
  end # action update
  
  def authenticate
    unless authenticate_user
      redirect_to "/articles/pendragon"
    end # unless
  end # method authenticate
  private :authenticate
  
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
end # controller SkillsController