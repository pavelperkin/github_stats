Github Scraper 1

[![Code Climate](https://codeclimate.com/github/pavelperkin/github_stats/badges/gpa.svg)](https://codeclimate.com/github/pavelperkin/github_stats)

[![Test Coverage](https://codeclimate.com/github/pavelperkin/github_stats/badges/coverage.svg)](https://codeclimate.com/github/pavelperkin/github_stats)

Configuration:

1) Clone this project to your projects dir:

```bash
git clone https://github.com/pavelperkin/github_stats.git
```

2) Run mysql server:

```bash
mysql.server restart
```

3) Run redis server in another terminal tab:

```bash
redis-server
```
4) Install all gems with:

```bash
bundle install
```

5) Create database and run migrations (maybe you will need change config/database.yml file):

```bash
bundle exec rake db:create
bundle exec rake db:migrate
```

6) Run application with puma:

```bash
puma
```

7) Open http://localhost:9292/ tab in you browser. You should see project dashboard.

8) To launch continuosly scraper follow the instructions:

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
