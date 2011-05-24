module ProjectsHelper
  def key_facts(params = {})
    facts = '<div class="key_facts"><h3><p>'
    
    facts += '</p></h3></div>'
    
    return facts.html_safe
  end # helper key_facts
  
  def key_fact(label, content)
    return '<em>' + label + ':</em> ' + content
  end # method key_fact
  private :key_fact
end # end module ProjectsHelper