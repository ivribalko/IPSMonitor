module Telegram
  class Answer
    def hello(name)
      "Hello, %s" % name
    end

    def watching(issue_number)
      "Started watching issue %s" % issue_number
    end

    def unwatched(issue_number)
      "Stopped watching issue %s" % issue_number
    end

    def no_status(issue_number)
      "Couldn't get status for issue %s" % issue_number
    end

    def stopped
      'All settings cleared. Bye.'
    end

    def unknown
      'Sorry?'
    end
  end
end