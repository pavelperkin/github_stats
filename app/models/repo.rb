class Repo < ActiveRecord::Base
  has_many :commits
  has_many :pulls
  belongs_to :organization

  validates :name, presence: true, uniqueness: { scope: :organization }
  validates :url, presence: true,
                  uniqueness: true,
                  format: { with: URI.regexp }
  validates :organization_id, presence: true,
                              numericality: { only_integer: true }

  after_update :get_todays_commits, if: Proc.new { |obj| obj.observed }
  after_update :get_pulls, if: Proc.new { |obj| obj.observed }

  def get_pulls
    Thread.new do
      Octokit.pull_requests("#{organization.name}/#{name}", state: 'all', per_page: 100).each do |pr|
        pulls.create(user_id: User.get_user_id(pr.user),
                     state: pr.state,
                     number: pr.number,
                     title: pr.title,
                     url: pr.html_url)
      end
      ActiveRecord::Base.connection.close
    end
  end

  def get_todays_commits
    Thread.new do
      Octokit.commits_since("#{organization.name}/#{name}", Date.today, per_page: 100).reverse.each do |commit|
        commits.create(user_id: User.get_user_id(commit.author),
                       message: commit.commit.message,
                       url: commit.html_url,
                       sha: commit.sha,
                       commited_at: commit.commit.committer.date,
                       organization_id: organization.id)
      end
      ActiveRecord::Base.connection.close
    end
  end

end
