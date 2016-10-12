class Activity < ApplicationRecord
  belongs_to :user

  validates :behavior, presence: true

  scope :feed, ->user_id do
    where "user_id in (select id from users where id = #{user_id}
      or id in (select followed_id from relationships
        where follower_id = #{user_id}))"
  end
  scope :recent, ->{order created_at: :desc}
end
