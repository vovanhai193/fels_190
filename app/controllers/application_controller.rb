class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "please_login"
      redirect_to login_url
    end
  end

  def load_user
    @user = User.find_by id: params[:id]
    if @user.nil?
      flash[:danger] = t "user.not_found"
      redirect_to root_path
    end
  end

  def correct_user
    load_user
    redirect_to root_path unless @user.is_user? current_user
  end

  def verify_admin
    unless logged_in? && current_user.admin?
      flash[:danger] = t "message.you_not_be_admin"
      redirect_to root_path
    end
  end

  def make_activity behavior, object = nil, user = current_user
    Activity.create! behavior: behavior,
      object: object.nil? ? nil : object.base_resource, user_id: user.id
  end
end
