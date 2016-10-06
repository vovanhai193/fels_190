class Word < ApplicationRecord
  belongs_to :category

  has_many :answers, dependent: :destroy

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

  validates :content, presence: true, length: {minimum: 3}

  def correct_answer
    self.answers.find_by is_correct: true
  end
end
