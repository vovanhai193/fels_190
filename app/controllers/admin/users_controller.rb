class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_user, only: :destroy

  def index
    @users = User.recent.paginate page: params[:page], per_page: Settings.per_page
  end

  def destroy
    if @user.destroy
      make_activity t("activity.destroy_user"), @user
      flash[:success] = t "message.delete_success"
      redirect_to admin_users_path
    else
      flash[:warning] = t "message.delete_fail"
      redirect_to root_path
    end
  end
end
