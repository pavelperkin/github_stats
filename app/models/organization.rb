class Organization < ActiveRecord::Base
  has_many :commits
  has_many :repos
  
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true,
                  uniqueness: true,
                  format: { with: URI.regexp }, on: :update
  validate :should_exist_on_github, only: :create

  before_validation :strip_name
  after_create :fill_all_data

  def strip_name
    name.strip!
  end

  def fill_all_data
    data_from_github = get_data_from_github
    set_url(data_from_github.html_url)
    create_org_repos
  end

  def set_url(org_url)
    update(url: org_url)
  end

  def create_org_repos
    get_repos.each do |repo|
      repos.create(name: repo.name, url: repo.html_url)
    end
  end

  private

  def should_exist_on_github
    begin
      get_data_from_github
    rescue Octokit::NotFound => e
      errors.add(:organization, I18n.t('errors.should_exist_on_github'))
    end
  end

  def get_data_from_github
    Octokit.org(name)
  end

  def get_repos
    Octokit.organization_repositories(name, per_page: 500)
  end

end
