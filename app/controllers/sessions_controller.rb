class SessionsController < ApplicationController
  def new
    if request.xhr?
      # AJAX request; serve the "new" form sans layout
      render :new, :layout => false
    else
      # standard http; redirect to route
      redirect_to root_url
    end # if-else
  end # action new

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      redirect_to root_url
    end # end if-else
  end # action create

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end # action destroy
end # controller SessionsController
