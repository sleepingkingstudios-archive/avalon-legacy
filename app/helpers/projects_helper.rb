module ProjectsHelper
  def key_facts(params = {})
    facts = '<div class="key_facts"><h3><p>'
    fact_array = Array.new
    
    if params[:language]
      language = params[:language]
      if language.respond_to? :join
        fact_array.push({ :label => "Language(s):", :content => language.join(", ") })
      else
        fact_array.push({ :label => "Language(s):", :content => language })
      end # if-else
    end # if
    
    fact_array.each do |fact|
      facts += key_fact fact[:label], fact[:content]
    end # each
    
    facts += '</p></h3></div>'
    
    return facts.html_safe
  end # helper key_facts
  
  def key_fact(label, content)
    return '<em>' + label + ':</em> ' + content
  end # method key_fact
  private :key_fact
end # end module ProjectsHelper