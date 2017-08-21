#!/usr/bin/env ruby

require 'io/console'
require 'require_all'
require_all 'database'
require_all 'ips'
require_all 'telegram'

TOKEN = '403748748:AAFosOYfAckovw8XDKwDNyXT7TKoAo-tJek'.freeze
DEBUG = ARGV.include?('-d')
DATABASE_URL = ENV['DATABASE_URL'] ||
               'postgres://ivan@localhost/ips_monitor'

Thread.abort_on_exception = DEBUG

db  = Database::Adapter.new
ips = IPS::Website.new
issues = db.issue_list

Database::IssueList.instance.add(issues)
issue_list = Database::IssueList.issues

operator = Telegram::Operator.new(db, TOKEN)
Thread.new { operator.run }

watcher = IPS::Watcher.new(ips, operator, issue_list)
Thread.new { watcher.run }

loop do
  # break if STDIN.getch == ' '
end
