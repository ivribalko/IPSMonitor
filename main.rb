#!/usr/bin/env ruby

require './ips_telegram_bot.rb'

TOKEN = '414895814:AAEgnlPOnKtQgcNpoHBvl0zGcpXJOPRUnSM'

ips = IPSWebsite.new
bot = IPSTelegramBot.new(ips, TOKEN)

bot.run
