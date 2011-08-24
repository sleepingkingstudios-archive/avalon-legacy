class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def recent_activity(params = {})
    activity = String.new
    
    github_list_commits(:repository => "sleepingkingstudios/camelot", :count => 3).each do |commit|
      activity += github_format_commit commit 
    end # each
    
    render :text => activity.html_safe
  end # action recent_activity
  
  before_filter :get_local_time, :get_theme_override
  
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