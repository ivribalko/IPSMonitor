#!/usr/bin/env ruby

require './module_database.rb'
require './module_ips.rb'
require './module_telegram.rb'
require 'io/console'

TOKEN = '403748748:AAFosOYfAckovw8XDKwDNyXT7TKoAo-tJek'.freeze

DB_ADAPTER = 'postgresql'.freeze
DB_USER = 'ivan'.freeze
DB_NAME = 'ips_monitor'.freeze

Thread.abort_on_exception = true

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
  break if STDIN.getch == ' '
end

Process.kill('INT', 0)
