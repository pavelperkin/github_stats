class Pull < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  has_many :comments, as: :commentable
end
