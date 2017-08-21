#!/usr/bin/env ruby

require 'io/console'
require 'require_all'
require_all 'database'
require_all 'ips'
require_all 'telegram'

TOKEN = '403748748:AAFosOYfAckovw8XDKwDNyXT7TKoAo-tJek'.freeze
DEBUG = ARGV.include?('-d')

Thread.abort_on_exception = DEBUG

db  = Database::Adapter.new
ips = IPS::Website.new
issues = db.issue_list

Database::IssueList.instance.add(issues)
issue_list = Database::IssueList.issues

watcher = IPS::Watcher.new(ips, operator, issue_list)
Thread.new { watcher.run }

operator = Telegram::Operator.new(db, TOKEN)
operator.run
