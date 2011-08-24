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
  
  def theme_select_bar(params = {})
    tag = params[:tag] || "p"
    tag_attrs = Hash.new
    
    tag_style = params[:style] || {}
    tag_style["text-align"] ||= "center"
    
    tag_attrs["style"] = (tag_style.map do |key, value| "#{key}: #{value};" end).join(" ")
    
    theme = "<#{tag} #{(tag_attrs.map do |key, value| "#{key}='#{value}'" end).join(" ")}>"
    
    theme += "It is now #{@time.hour}:#{@time.min}. It #{@is_it_dark ? "is" : "is not"} dark.#{@is_it_dark ? " You are likely to be eaten by a grue." : ""} "
    theme += "Choose a theme: "
    theme += "<a id='#theme_select_light' href='#light'>Light</a> | "
    theme += "<a id='#theme_select_dark' href='#dark'>Dark</a> "
    theme += "( <a id='#theme_select_auto' href='#auto'>Auto</a> )"
    
    theme += "</#{tag}}>"
    
    return theme.html_safe
  end # helper theme_select_bar
end # module ApplicationHelper