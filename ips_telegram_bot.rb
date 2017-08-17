require 'telegram/bot'
require './ips_website.rb'

class IPSTelegramBot	
  TOKEN = '414895814:AAEgnlPOnKtQgcNpoHBvl0zGcpXJOPRUnSM'
  MONITOR_START = '/start'
	MONITOR_END = '/end'

	def initialize
    ips = IPSWebsite.new
    run_bot(ips)
  end

def run_bot(ips)
  Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) do |bot|
      bot.listen do |message|
        send = lambda { |send_text| bot.api.send_message(chat_id: message.chat.id, text: send_text) }
        text = message.text

        if text.is_integer?
          status = ips.get_issue_status(text)
          send.call(!status.nil? ? status : "Не получилось узнать статус для заявки #{text}")
        else
          case text
          when MONITOR_START
            send.call("Hello, #{message.from.first_name}")
          when MONITOR_END
            send.call("Bye, #{message.from.first_name}")
          else
            send.call('Не понял')
          end
        end
      end
    end
  end
end

class String
  def is_integer?
    self.to_i.to_s == self
  end
end