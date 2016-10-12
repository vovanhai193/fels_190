class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      make_activity t "activity.login"
      redirect_back_or user
    else
      flash.now[:danger] = t "invalid"
      render :new
    end
  end

  def destroy
    if logged_in?
      make_activity t "activity.logout"
      log_out
    end
    redirect_to root_url
  end
end
