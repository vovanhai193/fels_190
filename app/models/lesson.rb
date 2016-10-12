class Lesson < ApplicationRecord
  belongs_to :category
  belongs_to :user

  has_many :results, dependent: :destroy
  has_many :words, through: :results
  has_many :answers, through: :results

  accepts_nested_attributes_for :results

  scope :of_user, ->user_id {where user_id: user_id}
  scope :recent, ->{order created_at: :desc}

  before_create :create_words

  def base_resource
    "\##{self.id} of category #{self.category.name}"
  end

  private

  def create_words
    self.words = self.category.words.order("RAND()").limit Settings.words_number
  end
end
