class User < ActiveRecord::Base
  has_many :commits

  validates :login, presence: true,
                    uniqueness: true
  validates :github_id, presence: true,
                        uniqueness: true,
                        numericality: { only_integer: true }
  validates :url, presence: true,
                  uniqueness: true,
                  format: { with: URI.regexp }
  validates :avatar_url,
                  format: { with: URI.regexp, allow_blank: true }
end
