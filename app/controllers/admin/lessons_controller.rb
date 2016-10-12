class Admin::LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_lesson, only: :destroy

  def index
    @lessons = Lesson.recent.includes(:user)
      .paginate page: params[:page], per_page: Settings.per_page
  end

  def destroy
    if @lesson.destroy
      make_activity t("activity.destroy_lesson"), @lesson
      flash[:success] = t "lesson.delete"
    else
      flash[:danger] = t "lesson.delete_fail"
    end
    redirect_to admin_lessons_path
  end

  private

  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    if @lesson.nil?
      flash[:danger] = t "lesson.not_found"
      redirect_to admin_lessons_path
    end
  end
end
