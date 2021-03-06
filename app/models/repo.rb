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

  scope :active, -> { where(observed: true) }

  after_update :get_todays_commits, :get_pulls, if: Proc.new { |obj| obj.observed }

  def full_name
    "#{organization.name}/#{name}"
  end

  def last_updated
    commits.last.try(:commited_at) || Date.today
  end

  def get_commits(period, per_page=100)
    Octokit.commits_since(full_name, period, per_page: per_page).reverse.each do |commit|
      commits.create(Commit.parse_data(commit).merge(organization: organization))
    end
  end

  private

  def get_pulls
    Thread.new do
      Octokit.pull_requests(full_name, state: 'all', per_page: 100).reverse.each do |pr|
        pulls.create(Pull.parse_data(pr))
      end
      ActiveRecord::Base.connection.close
    end
  end

  def get_todays_commits
    Thread.new do
      get_commits(1.day.ago)
      ActiveRecord::Base.connection.close
    end
  end

end
