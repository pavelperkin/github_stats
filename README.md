Github Scraper

[![Code Climate](https://codeclimate.com/github/pavelperkin/github_stats/badges/gpa.svg)](https://codeclimate.com/github/pavelperkin/github_stats)

[![Test Coverage](https://codeclimate.com/github/pavelperkin/github_stats/badges/coverage.svg)](https://codeclimate.com/github/pavelperkin/github_stats)

Configuration:

When you in root dir of Github Stats you should run: 
```bash
whenever -i
[write] crontab file updated
```

This comand will create a cron task for fetching data from github.
If you work not in production then you should update crontab:

Run:
```bash
crontab -e
```

And change RAILS_ENV to your environment in:
```bash
0,20,40 * * * * bash -l -c 'cd /Users/pavelperkin/projects/pets/github && RAILS_ENV=production bundle exec rake scrape_github --silent
```

Save changes.

You will get:
```bash
crontab: installing new crontab
```
