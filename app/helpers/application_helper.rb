module ApplicationHelper
  def navigation(params = {})
    nav_data = {
      :home => { :label => "home", :path => :root},
      :articles => { :label => "articles", :path => "/articles" },
      :projects => { :path => "/projects" },
      :blog => {},
      :about => { :path => :about },
      :sitemap => { :path => :sitemap }
    } # end nav_items
    
    # logger.debug "params = " + params.inspect
    
    nav_items = (params[:only].respond_to? :[]) ? params[:only] : [ :home, :articles, :projects, :blog, :about, :sitemap ]
    # logger.debug "nav_items = " + nav_items.inspect
    
    if params[:skip].respond_to? :[] then nav_items -= params[:skip] end
    
    nav = String.new
    nav_items.each do |key|
      item = nav_data[key]
      # logger.debug "item = " + item.inspect
      next if item.nil?
      nav += navigation_item({
        :label => (item[:label] || key),
        :path => item[:path],
        :children => item[:children],
        :tag => params[:tag],
        :tag_class => params[:tag_class]
      })
    end # each
    
    return nav.html_safe
  end # helper top_navigation
  
  def navigation_item(params = {})
    label = (params[:label] || "").to_s.capitalize
    path = params[:path] || ""
    children = params[:children] || Hash.new
    
    tag = (params[:tag] || "h2").to_s
    tag_class = (params[:tag_class].respond_to? :join) ? params[:tag_class].join(" ") : (params[:tag_class].to_s || "")
    
    # logger.debug "rendering navigation item: label = " + label + ", path = " + (path.nil? ? "nil" : path.to_s)
    
    item = "<" + tag + " class='" + "navigation_item navigation_" + label + (tag_class.empty? ? "" : " " + tag_class) + "'>" +
      (link_to_unless path.to_s.empty?, label, path) +
    "</" + tag + ">"
    
    # logger.debug '"' + item + '"'
    return item.html_safe
  end # method navigation_item
  private :navigation_item
  
  def recent_activity(params = {})
    activity = String.new
    
    github_list_commits(:repository => "sleepingkingstudios/camelot", :count => 3).each do |commit|
      activity += github_format_commit commit 
    end # each
    
    return activity.html_safe
  end # helper recent_activity
  
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
end # module ApplicationHelper