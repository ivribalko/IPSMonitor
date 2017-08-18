#!/usr/bin/env ruby

require './module-ips.rb'
require './module-telegram.rb'

TOKEN = '403748748:AAFosOYfAckovw8XDKwDNyXT7TKoAo-tJek'

ips = IPS::Website.new
bot = Telegram::Operator.new(ips, TOKEN)

bot.run