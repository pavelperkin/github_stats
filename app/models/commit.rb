class Commit < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  belongs_to :repo
  has_many :comments, as: :commentable
  
  validates :url, presence: true,
                  uniqueness: true,
                  format: { with: URI.regexp }
  validates :message, presence: true
  validates :sha, presence: true
  validates :commited_at, presence: true
  validates :user_id, presence: true,
                      numericality: { only_integer: true }

  scope :desc, -> { order(commited_at: :desc) }

  after_create do
    $redis.lpush("new_commits_for_#{organization_id}_org", with_username.to_json)
  end

  after_create :get_commit_comments

  def with_username
    attributes.merge(username: user.login)
  end

  def get_commit_comments
    Octokit.commit_comments("#{organization.name}/#{repo.name}", sha).each do |cc|
      comments.create(user_id: get_user_id(cc.user), body: cc.body, commented_at: cc.created_at)
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
