#!/usr/bin/env ruby

require './module-database.rb'
require './module-ips.rb'
require './module-telegram.rb'

TOKEN = '403748748:AAFosOYfAckovw8XDKwDNyXT7TKoAo-tJek'

db  = Database::Adapter.new
ips = IPS::Website.new
bot = Telegram::Operator.new(db, ips, TOKEN)

bot.run