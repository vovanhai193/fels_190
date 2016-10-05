class FollowersController < ApplicationController
  before_action :load_user

  def index
    @title = t "follow.followers"
    @users = @user.followers
  end
end
