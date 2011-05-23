class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :get_local_time, :get_theme_override
  
  def get_local_time
    Time.zone = 'EST'
    @time = Time.now
    @is_it_dark = @time.hour < 6 || @time.hour >= 18
  end # method get_local_time
  
  def get_theme_override
    # cookies[:override_theme] = "light"
    theme = cookies[:override_theme] || ""
    if theme.downcase == "light" then
      @theme_override = :light
    elsif theme.downcase == "dark" then
      @theme_override = :dark
    else
      @theme_override = :""
    end # if-elsif-else
  end # method get_theme_override
end # controller ApplicationController