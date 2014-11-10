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

  scope :active_for_last, ->(period) { joins(:commits)
                                       .group('users.id')
                                       .where('commits.commited_at > ?', period)
                                       .order('COUNT(commits.id) DESC')}

  class << self

    def get_user(data)
      find_user(data) || create_user(data)
    end

    def find_user(data)
      find_by(github_id: data.id)
    end

    def create_user(data)
      create(github_id: data.id,
             login: data.login,
             url: data.html_url,
             avatar_url: data.avatar_url)
    end

    def most_active_for_last_day
      active_for_last(1.day.ago).first(10)
    end

    def most_active_for_last_hour_for_repo(repo)
      active_for_last(1.hour.ago)
          .where('commits.repo_id = ?', repo.id)
          .first(10)
    end

  end

end
