class SessionsController < ApplicationController
  def new
    if request.xhr?
      # AJAX request; serve the "new" form sans layout
      render :new, :layout => false
    else
      # standard http; redirect to route
      redirect_to :root
    end # if-else
  end # action new

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      flash[:notices].push "Log in successful. What is thy bidding, my master?"
      flash.keep :notices
      logger.debug flash.inspect
      redirect_to root_url
    else
      flash[:errors].push "Invalid email or password"
      flash.keep :errors
      logger.debug flash.inspect
      redirect_to root_url
    end # end if-else
  end # action create

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Log out successful. You're all clear, kid, so let's blow this thing and go home!"
  end # action destroy
end # controller SessionsController
