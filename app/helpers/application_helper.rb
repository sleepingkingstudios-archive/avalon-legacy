module ApplicationHelper
  def navigation(params = {})
    nav_data = {
      :home => { :label => "home", :path => :root},
      :articles => { :label => "articles" },
      :projects => {},
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
      nav += self.navigation_item (item[:label] || key), item[:path], item[:children]
    end # each
    
    return nav.html_safe
  end # helper top_navigation
  
  def navigation_item(label, path = "", children = Hash.new)
    label = label.to_s.capitalize
    logger.debug "rendering navigation item: label = " + label + ", path = " + (path.nil? ? "nil" : path.to_s)
    
    item = "<div class='navigation_item navigation_" + label + "'>" +
      "<h2>" +
        (link_to_unless path.to_s.empty?, label, path) +
      "</h2>" +
    "</div>"
    
    logger.debug '"' + item + '"'
    return item.html_safe
  end # helper navigation_item
end # module ApplicationHelper