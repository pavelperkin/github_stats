class Repo < ActiveRecord::Base
  has_many :commits
  belongs_to :organization

  scope :active, -> { where(observed: true) }
  scope :inactive, -> { where(observed: false) }

  # after_create :get_today_commits

  def get_today_commits
    Octokit.commits_since("#{self.organization.name}/#{self.name}", Date.today).each do |commit|
      self.commits.create(user_id: 1,
                          message: commit.commit.message,
                          url: commit.html_url,
                          sha: commit.sha,
                          commited_at: commit.commit.committer.date,
                          organization_id: self.organization)
    end
  end
end



