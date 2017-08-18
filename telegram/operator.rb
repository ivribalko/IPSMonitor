require 'telegram/bot'

module Telegram
  class Operator
  	def initialize(ips, token)
      @ips = ips
      @answer = Answer.new
      @keyboard = Telegram::Bot::Types::ReplyKeyboardMarkup

      Telegram::Bot::Client.run(token, logger: Logger.new($stderr)) do |bot|
        @bot = bot
      end
    end

    def run
      @bot.listen do |message|
        @message = message
        case
        when is_command(Command::START)
          keyboard = keyboard([[Command::START, Command::WATCH, Command::UNWATCH, Command::STOP]])
          send(@answer.hello(message.from.first_name), keyboard)
        when is_command(Command::WATCH)
          issue_number = issue_number(message.text)
          send(@answer.watching(issue_number))
        when is_command(Command::UNWATCH)
          issue_number = issue_number(message.text)
          send(@answer.unwatched(issue_number))
        when is_command(Command::STOP)
          send(@answer.stopped)
        else
          send(@answer.unknown)
        end
      end
    end

    def send(text, *keyboard)
      @bot.api.send_message(chat_id: @message.chat.id, text: text, reply_markup: keyboard[0])
    end

    def keyboard(answers)
      @keyboard.new(keyboard: answers, one_time_keyboard: false)
    end

    def issue_number(text)
      text.scan(/\d/)[0]
    end

    def is_command(text)
      @message.text.start_with?(text)
    end
  end  
end