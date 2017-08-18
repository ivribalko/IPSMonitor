#!/usr/bin/env ruby
require 'pg'
conn = PG.connect(dbname: 'postgres')
  conn.exec("CREATE DATABASE ips_monitor")
  conn = PG.connect(dbname: 'ips_monitor')
  conn.exec("CREATE TABLE IF NOT EXISTS issues (
      id        integer PRIMARY KEY,
      user_ids  integer[]
  );")

require './module-database.rb'
require './module-ips.rb'
require './module-telegram.rb'

TOKEN = '403748748:AAFosOYfAckovw8XDKwDNyXT7TKoAo-tJek'

DB_ADAPTER = 'postgresql'
DB_USER = 'ivan'
DB_NAME = 'ips_monitor'

db  = Database::Adapter.new
ips = IPS::Website.new
bot = Telegram::Operator.new(db, ips, TOKEN)

bot.run