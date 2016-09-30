class Activity < ApplicationRecord
  belongs_to :user

  validates :behavior, presence: true
end
