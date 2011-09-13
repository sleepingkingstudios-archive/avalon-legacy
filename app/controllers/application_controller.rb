class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def authenticate_user(params = {})
    return false if (user = current_user).nil?
    
    # authenticate permissions here
    # (eventually)
    
    return true
  end # method authenticate_user
  
  def recent_activity(params = {})
    if request.xhr?
      # AJAX request; serve the "new" form sans layout
      activity = String.new
    
      github_list_commits(:repository => "sleepingkingstudios/camelot", :count => 3).each do |commit|
        activity += github_format_commit commit
      end # each
    
      render :text => activity.html_safe
    else
      # standard http; redirect to root
      redirect_to :root
    end # if-else
  end # action recent_activity
  
  before_filter :get_local_time, :get_theme_override
  before_filter :override_flash_notices, :except => :recent_activity
  
  def override_flash_notices
    logger.debug flash.inspect
    logger.debug flash.now.inspect
    %w(error warning notice).each do |key|
      single_key = key.intern
      plural_key = (key + "s").intern
      flash[plural_key] = [flash[plural_key] || []].push(flash[single_key]).flatten.compact.uniq
      flash.now[plural_key] = [flash.now[plural_key] || []].push(flash.now[single_key]).flatten.compact.uniq
    end # each
    logger.debug flash.inspect
    logger.debug flash.now.inspect
  end # method override_flash_notices
  
  def get_local_time
    Time.zone = 'EST'
    @time = Time.now
    @is_it_dark = @time.hour < 6 || @time.hour >= 18
  end # method get_local_time
  
  def get_theme_override
    # cookies[:override_theme] = "light"
    theme = cookies[:override_theme] || ""
    if theme.downcase == "light" then
      @theme_override = :light
    elsif theme.downcase == "dark" then
      @theme_override = :dark
    else
      @theme_override = :""
    end # if-elsif-else
  end # method get_theme_override
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end # helper current_user
  private :current_user
  helper_method :current_user
  
  def github_list_commits(params = {})
    return Array.new if params[:repository].nil?
    # logger.debug "#{self}: listing commits..."
    
    commits = Octokit.commits params[:repository]
    
    if params[:count]
      return commits[0..(params[:count].to_i - 1)]
    else
      return commits
    end # if-else
  end # method github_list_commits
  
  def github_format_commit(commit, params = {})
    tag = (params[:tag] || "li").to_s
    
    return "<#{tag}>Camelot: \"#{commit.message}\" at #{github_datetime commit.committed_date}</#{tag}>"
  end # method github_format_commit
  
  def github_datetime(date_string)
    date = nil
    /[\d\-]+T/.match(date_string) do |match|
      date = match[0]
      date = date[0..(date.size-2)]
    end # match
    
    time = nil
    /T[\d\-\:]+/.match(date_string) do |match|
      time = match[0]
      time = time[1..(time.size-1)]
    end # match
    
    # logger.debug "#{date_string}: \"#{date}\", \"#{time}\""
    return "#{date} #{time}"
  end # method github_datetime
  private :github_list_commits, :github_format_commit, :github_datetime
end # controller ApplicationController