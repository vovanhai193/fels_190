class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_category, except: [:index, :new, :create]

  def index
    @categories = Category.recent.paginate page: params[:page],
      per_page: Settings.category_page
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      make_activity t("activity.create_category"), @category
      flash[:success] = t "message.create_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "message.invalid_input"
      render :new
    end
  end

  def show
    @words = @category.words.recent.includes(:answers)
      .correct.references(:answers).paginate page: params[:page],
        per_page: Settings.category_page
  end

  def edit
  end

  def update
    if @category.update_attributes category_params
      make_activity t("activity.update_category"), @category
      flash[:success] = t "message.update_success"
      redirect_to admin_categories_path
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      make_activity t("activity.destroy_category"), @category
      flash[:success] = t "message.delete_success"
    else
      flash[:danger] = t "message.delete_fail"
    end
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit :name, :description
  end

  def load_category
    @category = Category.find_by id: params[:id]
    if @category.nil?
      flash[:danger] = t "category.not_found"
      redirect_to category_path
    end
  end
end
