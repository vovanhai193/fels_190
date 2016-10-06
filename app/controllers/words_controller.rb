class WordsController < ApplicationController
  before_action :logged_in_user

  def index
    @categories = Category.all
    if params[:category_id].blank?
      params[:option] ||= t "all_word"
      @words = Word.send params[:option], current_user.id
    else category = @categories.find_by(id: params[:category_id])
      @words = category.words.send params[:option], current_user.id
    end
    @words = @words.includes(:answers).paginate page: params[:page],
      per_page: (params[:per_page] || Settings.per_page)
  end
end
