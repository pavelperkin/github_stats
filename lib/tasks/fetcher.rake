task scrape_github: :environment  do
  logger = Logger.new("#{Rails.root}/log/scrape.log")
  Organization.all.each do |org|
    org.repos.active.each do |repo|
      get_commits(repo)
      get_pulls(repo)
      logger.info "Finished at #{Time.now}"
    end
  end
end

def get_commits(repo)
  Octokit.commits_since(repo.full_name, repo.last_updated, per_page: 100).reverse.each do |commit|
    repo.commits.create(Commit.parse_data(commit).merge(organization: repo.organization))
  end
end


def get_pulls(repo)
  Octokit.pull_requests(repo.full_name, state: 'all', per_page: 10).each do |pr|
    repo.pulls.create(Pull.parse_data(pr))
  end
end
