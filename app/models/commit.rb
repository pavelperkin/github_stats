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

  after_create :push_to_redis_queue, :get_commit_comments

  class << self

    def parse_data(data)
      { user: User.get_user(data.author),
        message: data.commit.message,
        url: data.html_url,
        sha: data.sha,
        commited_at: data.commit.committer.date }
    end

  end

  def get_commit_comments
    get_comments_from_github.each do |cc|
      comments.create(Comment.parse_data(cc))
    end
  end

  def get_comments_from_github
    Octokit.commit_comments(repo.full_name, sha)
  end

  def push_to_redis_queue
    $redis.lpush(redis_queue, with_username_and_repo.to_json)
  end

  private

  def redis_queue
    "new_commits_for_#{organization_id}_org"
  end

  def with_username_and_repo
    attributes.merge(username: user.login, repo_name: repo.name)
  end

end
