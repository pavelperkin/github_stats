class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
  validates :commented_at, presence: true
  validates :user_id, presence: true,
                      numericality: { only_integer: true }

  class << self

    def parse_data(data)
      { user: User.get_user(data.user),
        body: data.body,
        commented_at: data.created_at }
    end

  end
end
