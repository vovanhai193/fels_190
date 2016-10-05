class FollowingController < ApplicationController
  before_action :load_user

  def index
    @title = t "follow.following"
    @users = @user.following
  end
end
