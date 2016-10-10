class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user_following = current_user.following.size
      @user_followers = current_user.followers.size
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
