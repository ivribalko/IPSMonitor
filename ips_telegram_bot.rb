require 'telegram/bot'
require './ips_website.rb'

class IPSTelegramBot
	def initialize(ips, token)
    @ips = ips
    
    Telegram::Bot::Client.run(token, logger: Logger.new($stderr)) do |bot|
      @bot = bot
    end
  end

  def run
    @bot.listen do |message|
      @message = message
      text = message.text

      if !text.nil? && text.is_integer?
        status = @ips.get_issue_status(text)
        send(!status.nil? ? status : "Couldn't get status for issue #{text}")
      else
        case text
        when 1
          send("Hello, #{message.from.first_name}")
        when 2
          send("Bye, #{message.from.first_name}")
        else
          send('Sorry?')
        end
      end
    end
  end

  def send(text)
    @bot.api.send_message(chat_id: @message.chat.id, text: text)
  end
end

class String
  def is_integer?
    self.to_i.to_s == self
  end
end