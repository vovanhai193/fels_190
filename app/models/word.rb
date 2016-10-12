class Word < ApplicationRecord
  belongs_to :category

  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true

  scope :recent, ->{order created_at: :desc}

  scope :all_word, ->user_id{}
  scope :learned, ->user_id do
    where "id in (select word_id from answers where is_correct = true
      and id in (select answer_id from results where lesson_id in
        (select id from lessons where user_id = #{user_id})))"
  end
  scope :no_learn, ->user_id do
    where "id not in (select word_id from answers where is_correct = true
      and id in (select answer_id from results where lesson_id in
        (select id from lessons where user_id = #{user_id})))"
  end
  scope :correct, ->{where "answers.is_correct = true"}

  validates :content, presence: true, length: {minimum: 3}
  validate :check_answer_number

  def correct_answer
    self.answers.find_by is_correct: true
  end

  def base_resource
    "'#{self.content}' of category #{self.category.name}"
  end

  private

  def check_answer_number
    unless self.answers.select{|answer| answer.is_correct}.size ==
      Settings.correct_answer_number
      errors.add :word, I18n.t("some_answers_more_than_1")
    end
  end
end
