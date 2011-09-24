module OldArticlesHelper
  def articles_link(body, url, html_options = {})
    url.insert(0, "/") unless url.match(/^\//)
    url.insert(0, articles_path)
    prepend = html_options.delete(:prepend).to_s
    append  = html_options.delete(:append).to_s
    
    return "#{prepend}#{link_to(body, url, html_options)}#{append}".html_safe
  end # helper articles_link
  
  def pendragon_skill_link(name)
    slug = PendragonSkill.convert_name_to_slug name
    return link_to name, [:articles, PendragonSkill.find_by_slug(slug)]
  end # helper pendragon_skill_link
end # module OldArticlesHelper
