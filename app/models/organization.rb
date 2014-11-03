class Organization < ActiveRecord::Base
  has_many :commits
  
  validates :name, presence: true, uniqueness: true

end
