class ArticlesController < ApplicationController
  # GET /articles
  def index
  end # action index
  
  # GET /articles/:path
  def static
    prefix = Dir.pwd + "/app/views/"
    # logger.debug "articles parent directory = #{prefix}"
    
    path_tokens = "articles/#{params[:path]}".split("/")
    # logger.debug "path tokens = #{path_tokens.inspect}"
    
    file_content = ""
    rendered_file = ""
    
    @errors = nil
    @layouts = nil
    
    highest_valid_index = -1
    path_tokens.each_with_index do |token, index|
      path = path_tokens[0..index].join("/")
      # logger.debug "checking path \"#{path}\""
      
      if index < path_tokens.length - 1
        # check each directory along the path
        
        if path_is_directory? "#{prefix}#{path}"
          highest_valid_index = index
        else
          @errors ||= []
          @errors.push "Unable to locate directory at \"#{path}\""
          logger.error @errors.last
          break
        end # if-else path_is_directory?
      else
        if path_is_file? "#{prefix}#{path}.html.haml"
          logger.debug "Located file at \"#{path}.html.haml\""
          @layouts = render_layouts(prefix, path_tokens)
          rendered_file = render_to_string :file => "#{prefix}#{path}.html.haml"
        elsif path_is_directory? "#{prefix}#{path}"
          # logger.debug "Located directory at \"#{path}\", checking for index"
          if path_is_file? "#{prefix}#{path}/index.html.haml"
            # logger.debug "Located index file at #{path}/index.html.haml"
            @layouts = render_layouts(prefix, path_tokens)
            rendered_file = render_to_string :file => "#{prefix}#{path}/index.html.haml"
          else
            @errors ||= []
            @errors.push "Unable to locate index for directory \"#{path}\""
            logger.error @errors.last
          end # if
        else
          @errors ||= []
          @errors.push "Unable to locate file or directory at \"#{path}\""
          logger.error @errors.last
          break
        end # if-elsif-if
      end # if-else
    end # each_with_index
    
    if rendered_file.empty?
      # logger.debug "last index = #{highest_valid_index}"
      highest_valid_index.downto(0) do |index|
        path = path_tokens[0..index].join('/')
        if path_is_file? "#{prefix}#{path}/index.html.haml"
          # logger.debug "Located index file at #{path}/index.html.haml"
          @layouts = render_layouts(prefix, path_tokens[0..index])
          rendered_file = (render_to_string :file => "#{prefix}#{path}/index.html.haml") and break
        else
          @errors ||= []
          @errors.push "Unable to locate index for directory \"#{path}\""
          logger.error @errors.last
        end # if
      end # downto
    end # if rendered_file.empty?
    
    unless rendered_file.empty?
      # logger.debug "Rendering from string, with layouts..."
      render :text => "#{rendered_file}" and return
    end # unless rendered_file.empty?
    
    redirect_to :index
  end # action static
  
  private
  
  def path_is_directory?(path);
    return File.directory? path
  end # method path_is_directory?
  
  def path_is_file?(path)
    # logger.debug "Evaluating existence of file at \"#{path}\""
    return File.exists? path
  end # method path_is_file?
  
  def render_layouts(prefix, path_tokens, file_name = "_layout.html.haml")
    layouts = []
    
    path_tokens.each_index do |index|
      path = path_tokens[0..index].join("/")
      concat_path = "#{prefix}#{path}/#{file_name}"
      if path_is_file? concat_path
        begin
          # logger.debug "Loading layout #{concat_path}"
          layouts.push File.read concat_path
        rescue Exception => exception
          logger.error exception.message
        end # begin-rescue
      else
        # logger.debug "Unable to locate layout at #{concat_path}"
      end # if path_is_file?
    end # each_index
    
    return layouts.reverse
  end # method render_layouts
end # controller ArticlesController