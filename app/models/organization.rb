class Organization < ActiveRecord::Base
  has_many :commits
  
  validates :name, presence: true, uniqueness: true
  validate :should_exist_on_github, only: :create

  after_create :fill_all_data

  def fill_all_data
    data_from_github = get_data_from_github
    set_url(data_from_github.html_url)
  end

  def set_url(org_url)
    update(url: org_url)
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

end
