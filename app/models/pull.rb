class Pull < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  has_many :comments, as: :commentable

  validates :number, presence: true,
                     uniqueness: { scope: :repo },
                     numericality: { only_integer: true }
  validates :state, inclusion: { in: %w(open closed)}
  validates :title, presence: true
  validates :url, presence: true,
                  uniqueness: true,
                  format: { with: URI.regexp }
  validates :user_id, presence: true,
                      numericality: { only_integer: true }
  validates :repo_id, presence: true,
                      numericality: { only_integer: true }

  after_create :get_pull_comments

  def get_pull_comments
    Octokit.pull_request_comments("#{repo.organization.name}/#{repo.name}", number).each do |prc|
      comments.create(user_id: get_user_id(prc.user), body: prc.body, commented_at: prc.created_at)
    end
  end

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
