module ArticlesHelper
  def pendragon_skill_link(name)
    slug = PendragonSkill.convert_name_to_slug name
    return link_to name, [:articles, PendragonSkill.find_by_slug(slug)]
  end # helper pendragon_skill_link
end # module ArticlesHelper
