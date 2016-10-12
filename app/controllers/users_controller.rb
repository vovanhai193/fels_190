class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :load_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.recent.paginate page: params[:page], per_page: Settings.per_page
  end

  def show
    @user_following = @user.following.size
    @user_followers = @user.followers.size
    @activities = @user.activities.recent.paginate page: params[:page],
      per_page: Settings.per_page if logged_in?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      make_activity t("activity.signup"), nil, @user
      log_in @user
      make_activity t "activity.login"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "user.success"
      make_activity t "activity.update_profile"
      redirect_to @user
    else
      flash[:danger] = t "user.danger"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
