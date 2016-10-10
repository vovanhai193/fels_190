class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :load_lesson, only: [:update, :show, :destroy]

  def show
  end

  def create
    @category = Category.find_by id: params[:category_id]
    if @category.nil?
      flash[:success] = t "category.not_found"
      redirect_to categories_path
    end
    @lesson = Lesson.new category_id: @category.id, user_id: current_user.id
    if @lesson.save
      flash[:success] = t "lesson.create_success"
      redirect_to @lesson
    else
      flash[:danger] = t "lesson.create_failed"
      redirect_to @category
    end
  end

  def update
    if @lesson.update_attributes lesson_params
      flash[:success] = t "lesson.submit"
    else
      flash[:danger] = t "lesson.not_submit"
    end
    redirect_to @lesson.category
  end

  def destroy
    @lesson.destroy
    flash[:success] = t "lesson.delete"
    redirect_to @lesson.category
  end

  private

  def lesson_params
    params.require(:lesson).permit :learned, results_attributes: [:id, :answer_id]
  end

  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    if @lesson.nil?
      flash[:danger] = t "lesson.not_found"
      redirect_to categories_path
    end
  end
end
