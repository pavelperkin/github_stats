class Repo < ActiveRecord::Base
  has_many :commits
  has_many :pulls
  belongs_to :organization

  after_update :get_todays_commits, if: Proc.new { |obj| obj.observed }
  after_update :get_pulls, if: Proc.new { |obj| obj.observed }

  def get_pulls
    Thread.new do
      Octokit.pull_requests("#{organization.name}/#{name}", state: 'all', per_page: 100).each do |pr|
        pulls.create(user_id: get_user_id(pr.user),
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
      Octokit.commits_since("#{organization.name}/#{name}", Date.today, per_page: 100).each do |commit|
        commits.create(user_id: get_user_id(commit.author),
                       message: commit.commit.message,
                       url: commit.html_url,
                       sha: commit.sha,
                       commited_at: commit.commit.committer.date,
                       organization_id: organization.id)
      end
      ActiveRecord::Base.connection.close
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



