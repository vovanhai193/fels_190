class CategoriesController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.includes(:words).paginate page: params[:page],
      per_page: Settings.category_page
  end

  def show
    @category = Category.find_by id: params[:id]
    if @category.nil?
      flash[:danger] = t "category.not_found"
      redirect_to root_path
    else
      @lessons = @category.lessons.of_user(current_user.id)
        .paginate page: params[:page], per_page: Settings.category_page
    end
  end
end
