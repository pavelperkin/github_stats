class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
  validates :commented_at, presence: true
  validates :user_id, presence: true,
                      numericality: { only_integer: true }

end
