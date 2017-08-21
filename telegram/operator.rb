require 'telegram/bot'

module Telegram
  # Telegram bot worker
  class Operator
    def initialize(db, token)
      @db = db
      @answer = Answer.new
      @keyboard = Telegram::Bot::Types::ReplyKeyboardMarkup

      Telegram::Bot::Client.run(token, logger: Logger.new($stderr)) do |bot|
        @bot = bot
      end
    end

    def run
      @bot.listen do |message|
        @message = message

        _ = start_command? ||
            watch_command? ||
            unwatch_command? ||
            list_command? ||
            stop_command? ||
            unknown_command
      end
    end

    def start_command?
      return false unless command?(Command::START)

      keyboard = keyboard(
        [
          [Command::WATCH, Command::UNWATCH, Command::LIST],
          [Command::START, Command::STOP]
        ]
      )
      send(@answer.hello(@message.from.first_name), keyboard)
      true
    end

    def watch_command?
      return false unless command?(Command::WATCH)

      issue_id = issue_id_or_error(@message.text)
      if issue_id
        @db.add_user_issue(issue_id, @message.chat.id)
        send(@answer.watching(issue_id))
      end
      true
    end

    def unwatch_command?
      return false unless command?(Command::UNWATCH)

      issue_id = issue_id_or_error(@message.text)
      if issue_id
        @db.remove_user_issue(issue_id, @message.chat.id)
        send(@answer.unwatched(issue_id))
      end
      true
    end

    def list_command?
      return false unless command?(Command::LIST)

      issues = @db.user_issue_list(@message.from.id)
      send(@answer.issue_list(issues))
      true
    end

    def stop_command?
      return false unless command?(Command::STOP)

      send(@answer.stopped)
      true
    end

    def unknown_command
      send(@answer.unknown)
    end

    def send(text, *keyboard)
      @bot.api.send_message(
        chat_id: @message.chat.id,
        text: text,
        reply_markup: keyboard[0]
      )
    end

    def send_to_chat(chat_id, text)
      @bot.api.send_message(chat_id: chat_id, text: text)
    end

    def keyboard(answers)
      @keyboard.new(keyboard: answers, one_time_keyboard: false)
    end

    def issue_id_or_error(text)
      result = text.scan(/\d+/)[0]
      result.nil? && send(@answer.incorrect_issue_id(result))
      result
    end

    def command?(text)
      @message.text.start_with?(text)
    end
  end
end
