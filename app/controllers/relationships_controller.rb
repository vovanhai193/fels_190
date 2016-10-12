class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    check_user_nil @user
    current_user.follow @user
    make_activity t("activity.follow"), @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    check_user_nil @user
    current_user.unfollow @user
    make_activity t("activity.unfollow"), @user
    respond_to do |format|
      format.html {redirect_to @user}
      format.js
    end
  end

  private

  def check_user_nil user
    if user.nil?
      flash[:danger] = t "user.not_found"
      redirect_to root_path
    end
  end
end
