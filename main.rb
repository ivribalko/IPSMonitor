#!/usr/bin/env ruby

require './module-database.rb'
require './module-ips.rb'
require './module-telegram.rb'

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

watcher = IPS::Watcher.new(ips, issue_list)
watcher_thread = Thread.new { watcher.run }

bot = Telegram::Operator.new(db, ips, TOKEN)
bot.run

# watcher_thread.stop
# watcher_thread.join