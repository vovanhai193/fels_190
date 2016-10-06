class WordsController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.all
    category = @categories.find_by id: params[:category_id]
    if params[:category_id].blank?
      params[:option] ||= t "all_word"
      @words = Word.send params[:option], current_user.id
    elsif category.nil?
      flash[:danger] = t "category.not_found"
      @words = Word.send params[:option], current_user.id
    else
      @words = category.words.send params[:option], current_user.id
    end
    @words = @words.includes(:answers).paginate page: params[:page],
      per_page: (params[:per_page] || Settings.per_page)
  end
end
