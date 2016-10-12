class Admin::WordsController < ApplicationController
  before_action :logged_in_user, :verify_admin
  before_action :load_word, only: [:edit, :update, :destroy]
  before_action :load_category, only: [:new, :create]

  def new
    @word = @category.words.build
    Settings.answer_number.times do
      @word.answers.build
    end
  end

  def create
    @word = @category.words.build word_params
    if @word.save
      make_activity t("activity.create_word"), @word
      flash[:success] = t "word.create_success"
      redirect_to [:admin, @category]
    else
      flash.now[:danger] = t "word.create_failed"
      render :new
    end
  end

  def edit
  end

  def update
    if @word.update_attributes word_params
      make_activity t("activity.update_word"), @word
      flash[:success] = t "word.update_success"
      redirect_to [:admin, @word.category]
    else
      flash.now[:danger] = t "word.update_failed"
      render :edit
    end
  end

  def destroy
    if @word.destroy
      make_activity t("activity.destroy_word"), @word
      flash[:success] = t "word.delete_success"
    else
      flash[:danger] = t "word.delete_failed"
    end
    redirect_to [:admin, @word.category]
  end

  private

  def word_params
    params.require(:word).permit :content, :category_id,
      answers_attributes: [:id, :content, :is_correct]
  end

  def load_word
    @word = Word.find_by id: params[:id]
    if @word.nil?
      flash[:danger] = t "word.not_found"
      redirect_to admin_categories_path
    end
  end

  def load_category
    @category = Category.find_by id: params[:category_id]
    if @category.nil?
      flash[:danger] = t "word.not_found"
      redirect_to admin_categories_path
    end
  end
end
