#!/usr/bin/env ruby

require './module-database.rb'
require './module-ips.rb'
require './module-telegram.rb'
require 'io/console'

TOKEN = '403748748:AAFosOYfAckovw8XDKwDNyXT7TKoAo-tJek'

DB_ADAPTER = 'postgresql'
DB_USER = 'ivan'
DB_NAME = 'ips_monitor'

Thread.abort_on_exception=true

db  = Database::Adapter.new
ips = IPS::Website.new
issues = db.get_issue_list

Database::IssueList.instance.add(issues)
issue_list = Database::IssueList.issues

operator = Telegram::Operator.new(db, TOKEN)
operator_thread = Thread.new { operator.run }

watcher = IPS::Watcher.new(ips, operator, issue_list)
watcher_thread = Thread.new { watcher.run }

loop do
  break if STDIN.getch == ' '
end

Process.kill('INT', 0)

# watcher_thread.stop
# watcher_thread.join