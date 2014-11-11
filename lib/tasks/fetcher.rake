task scrape_github: :environment  do
  logger = Logger.new("#{Rails.root}/log/scrape.log")
  Organization.all.each do |org|
    org.repos.active.each do |repo|
      get_commits(repo)
      get_pulls(repo)
      get_comments(repo.pulls)
      get_comments(repo.commits)
      logger.info "Finished at #{Time.now}"
    end
  end
end

def get_commits(repo)
  repo.get_commits(repo.last_updated, 100)
end

def get_pulls(repo)
  Octokit.pull_requests(repo.full_name, state: 'all', per_page: 10).each do |pr|
    old_pull = repo.pulls.where(number: pr.number).first
    if old_pull.present?
      old_pull.update(Pull.parse_data(pr)) if old_pull.last_update < pr.updated_at
    else
      repo.pulls.create(Pull.parse_data(pr))
    end
  end
end

def get_comments(comment_objects)
  comment_objects.each do |co|
    co.get_comments_from_github.each do |comment|
      if co.comments.find_by(github_id: comment.id).nil?
        co.comments.create(Comment.parse_data(comment))
      end
    end
  end
end
