class Pull < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  has_many :comments, as: :commentable

  validates :number, presence: true,
                     uniqueness: { scope: :repo },
                     numericality: { only_integer: true }
  validates :state, inclusion: { in: %w(open closed)}
  validates :title, presence: true
  validates :url, presence: true,
                  uniqueness: true,
                  format: { with: URI.regexp }
  validates :user_id, presence: true,
                      numericality: { only_integer: true }
  validates :repo_id, presence: true,
                      numericality: { only_integer: true }

  after_create :get_pull_comments

  def get_pull_comments
    Octokit.pull_request_comments(repo.full_name, number).each do |prc|
      comments.create(Comment.parse_data(prc))
    end
  end

end
