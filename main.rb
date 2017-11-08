#!/usr/bin/env ruby

require 'io/console'
require 'require_all'
require_all 'database'
require_all 'ips'
require_all 'telegram'

TOKEN = ENV['TOKEN']
DEBUG = ARGV.include?('-d')
DATABASE_URL = ENV['DATABASE_URL'] ||
               'postgres://ivan@localhost/ips_monitor'

Thread.abort_on_exception = DEBUG

website = IPS::Website.new
db_adapter = Database::Adapter.new(website)
issues = db_adapter.issue_list

Database::IssueList.instance.add(issues)
issue_list = Database::IssueList.issues

operator = Telegram::Operator.new(db_adapter, TOKEN)
Thread.new { operator.run }

watcher = IPS::Watcher.new(website, operator, issue_list)
Thread.new { watcher.run }

loop do
  # break if STDIN.getch == ' '
end
