class User < ActiveRecord::Base
  has_many :commits
  has_many :pulls

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

  class << self

    def get_user_id(data)
      (find_user(data) || create_user(data)).id
    end

    def find_user(data)
      User.find_by(github_id: data.id)
    end

    def create_user(data)
      User.create(github_id: data.id,
                  login: data.login,
                  url: data.html_url,
                  avatar_url: data.avatar_url)
    end
  end

end
