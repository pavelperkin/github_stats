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
  validates :organization_id, presence: true,
                      numericality: { only_integer: true }
  validates :repo_id, presence: true,
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
      comments.create(user_id: User.get_user_id(cc.user), body: cc.body, commented_at: cc.created_at)
    end
  end

end
