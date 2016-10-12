class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user_following = current_user.following.size
      @user_followers = current_user.followers.size
      @activities = Activity.feed(current_user.id).recent
        .paginate page: params[:page], per_page: Settings.per_page
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
