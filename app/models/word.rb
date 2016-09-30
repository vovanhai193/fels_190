class Word < ApplicationRecord
  belongs_to :category

  has_many :answers, dependent: :destroy

  validates :content, presence: true, length: {minimum: 3}
end
