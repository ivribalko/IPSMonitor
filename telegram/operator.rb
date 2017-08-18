require 'telegram/bot'

module Telegram
  class Operator
  	def initialize(db, ips, token)
      @db = db
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
          keyboard = keyboard([[Command::WATCH, Command::UNWATCH, Command::LIST], [Command::START, Command::STOP]])
          send(@answer.hello(message.from.first_name), keyboard)

        when is_command(Command::WATCH)
          issue_number = issue_number_or_error(message.text)
          unless issue_number.nil?
            @db.add_user_issue(issue_number, message.from.id)
            send(@answer.watching(issue_number))
          end

        when is_command(Command::UNWATCH)
          issue_number = issue_number_or_error(message.text)
          unless issue_number.nil?
            @db.remove_user_issue(issue_number, message.from.id)
            send(@answer.unwatched(issue_number))
          end

        when is_command(Command::LIST)
          issues = @db.get_issue_list(message.from.id)
          send(@answer.issue_list(issues))

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

    def issue_number_or_error(text)
      result = text.scan(/\d/)[0]

      if result.nil?
        send(@answer.incorrect_issue_number(result))
      end

      return result
    end

    def is_command(text)
      @message.text.start_with?(text)
    end
  end  
end