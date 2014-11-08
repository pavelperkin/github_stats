task scrape_github: :environment  do
  Organization.all.each do |org|
    org.repos.first.get_todays_commits
  end
end
