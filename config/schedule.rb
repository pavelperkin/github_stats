require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
set :path, Rails.root
set :output, Rails.root.join('log', 'cron.log')
set :job_template, "bash -l -c ':job'"

every 5.minutes do
  rake "scrape_github"
end
