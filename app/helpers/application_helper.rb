module ApplicationHelper
  def navigation(params = {})
    nav_data = {
      :home => { :label => "home", :path => :root},
      :articles => { :label => "articles" },
      :projects => { :path => "projects" },
      :blog => {},
      :about => { :path => :about },
      :sitemap => { :path => :sitemap }
    } # end nav_items
    
    logger.debug "params = " + params.inspect
    
    nav_items = (params[:only].respond_to? :[]) ? params[:only] : [ :home, :articles, :projects, :blog, :about, :sitemap ]
    logger.debug "nav_items = " + nav_items.inspect
    
    if params[:skip].respond_to? :[] then nav_items -= params[:skip] end
    
    nav = String.new
    nav_items.each do |key|
      item = nav_data[key]
      logger.debug "item = " + item.inspect
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
    
    logger.debug "rendering navigation item: label = " + label + ", path = " + (path.nil? ? "nil" : path.to_s)
    
    item = "<" + tag + " class='" + "navigation_item navigation_" + label + (tag_class.empty? ? "" : " " + tag_class) + "'>" +
      (link_to_unless path.to_s.empty?, label, path) +
    "</" + tag + ">"
    
    logger.debug '"' + item + '"'
    return item.html_safe
  end # method navigation_item
  private :navigation_item
end # module ApplicationHelper