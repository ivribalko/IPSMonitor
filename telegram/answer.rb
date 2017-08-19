module Telegram
  class Answer
    def hello(name)
      "Hello, %s" % name
    end

    def watching(issue_id)
      "Started watching issue %s" % issue_id
    end

    def unwatched(issue_id)
      "Stopped watching issue %s" % issue_id
    end

    def no_status(issue_id)
      "Couldn't get status for issue %s" % issue_id
    end

    def incorrect_issue_id(issue_id)
      "Issue number '%s' is incorrect" % issue_id
    end

    def issue_list(issues)
      "Issues: %s" % issues.join(", ")
    end

    def stopped
      'All settings cleared. Bye.'
    end

    def unknown
      'Sorry?'
    end
  end
end