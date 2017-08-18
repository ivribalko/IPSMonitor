#!/usr/bin/env ruby

require './ips_telegram_bot.rb'

TOKEN = '403748748:AAFosOYfAckovw8XDKwDNyXT7TKoAo-tJek'

ips = IPSWebsite.new
bot = IPSTelegramBot.new(ips, TOKEN)

bot.run