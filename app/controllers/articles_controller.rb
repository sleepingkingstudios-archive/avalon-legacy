class ArticlesController < ApplicationController
  # GET /articles/:path
  def index
  end # action index
  
  def static
    @prefix = Dir.getwd + "/app/views/articles/"
    @path = params[:path]
    @render_me = nil
    logger.debug "Received path variable \"" + @path + "\""
    logger.debug "Current path = " + @prefix
    
    # @error = "Have you tried turning it off and on again? Well, try harder!"
    
    # check if path to directory
    if @render_me.nil?
      logger.debug "Checking for directory..."
      @render_me = render_directory(@prefix + @path)
      logger.debug(@render_me.nil? ? "Did not find directory at #{@prefix + @path}/" : "Found directory at #{@prefix + @path}/")
    end # if
    
    # check if path to file
    if @render_me.nil?
      logger.debug "Checking for file..."
      @render_me = render_file(@prefix + @path)
      logger.debug(@render_me.nil? ? "Did not find file at #{@prefix + @path}.html.haml" : "Found file at #{@prefix + @path}.html.haml")
    end # if
    
    # try walking up the path
    while(@render_me.nil? && (segments = @path.split("/")) && segments.length > 1)
      @error = "Unable to locate article or directory at \"articles/#{@path}\""
      
      segments.pop
      @path = segments.join("/")
      @render_me = render_directory(@prefix + @path)
      logger.debug(@render_me.nil? ? "Did not find directory at #{@prefix + @path}/" : "Found directory at #{@prefix + @path}/")
    end # while
    
    unless @render_me.nil?
      render :text => @render_me
    else
      @error = "Unable to locate article or directory at \"articles/#{@path}\""
      render "/articles/index"
    end # unless-else
  end # action static
  
  private
  
  def render_directory(path, index = "/index.html.haml")
    rendered_layout = ""
    if File.exists?(path + "_layout.html.haml")
      rendered_layout = render_to_string(path + "_layout.html.haml")
    end # if
    if File.exists?(path + index)
      return rendered_layout + render_to_string(path + index)
    end # if
    return nil
  end # method render_directory
  
  def render_file(path, suffix = ".html.haml")
    if File.exists?(path + suffix)
      return render_to_string(path + suffix)
    end # if
    return nil
  end # method render_file
end # controller ArticlesController