class Pull < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  has_many :comments, as: :commentable

  validates :number, presence: true,
                     uniqueness: { scope: :repo },
                     numericality: { only_integer: true }
  validates :state, inclusion: { in: %w(open closed)}
  validates :title, presence: true
  validates :last_update, presence: true
  validates :url, presence: true,
                  uniqueness: true,
                  format: { with: URI.regexp }
  validates :user_id, presence: true,
                      numericality: { only_integer: true }
  validates :repo_id, presence: true,
                      numericality: { only_integer: true }

  after_create :get_pull_comments

  scope :desc, -> { order(number: :desc) }

  class << self

    def parse_data(data)
      { user: User.get_user(data.user),
        state: data.state,
        number: data.number,
        title: data.title,
        url: data.html_url,
        last_update: data.updated_at }
    end

  end

  def get_pull_comments
    get_comments_from_github.each do |prc|
      comments.create(Comment.parse_data(prc))
    end
  end

  def get_comments_from_github
    Octokit.pull_request_comments(repo.full_name, number)
  end

end
