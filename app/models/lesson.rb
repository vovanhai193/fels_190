class Lesson < ApplicationRecord
  belongs_to :category
  belongs_to :user
  	
  has_many :results, dependent: :destroy
  has_many :words, through: :results
  has_many :answers, through: :results

  scope :of_user, ->user_id {where user_id: user_id}
end
