module Telegram
  class Answer
    def initialize
      @website = IPS::Website.new #TODO
    end

    def hello(name)
      "Hello, %s" % name
    end

    def watching(issue_id)
      "Started watching issue #{issue_id}\n#{@website.issue_website_path(issue_id)}"
    end

    def unwatched(issue_id)
      "Stopped watching issue #{issue_id}"
    end

    def no_status(issue_id)
      "Couldn't get status for issue #{issue_id}\n#{@website.issue_website_path(issue_id)}"
    end

    def incorrect_issue_id(issue_id)
      "Issue number '%s' is incorrect" % issue_id
    end

    def issue_list(issues)
      "Issues: %s" % issues.join(", ")
    end

    def issue_updated_status(issue_id, status)
      "⏹ Issue #{issue_id} status updated:\n#{status}\n#{@website.issue_website_path(issue_id)}"
    end

    def issue_updated_incoming(issue_id, last_incoming)
      "⬇️ Issue #{issue_id} new incoming:\n#{last_incoming}\n#{@website.issue_website_path(issue_id)}"
    end

    def issue_updated_outcoming(issue_id, last_outcoming)
      "⬆️ Issue #{issue_id} new outcoming:\n#{last_outcoming}\n#{@website.issue_website_path(issue_id)}"
    end

    def stopped
      'All settings cleared. Bye.'
    end

    def unknown
      'Sorry?'
    end
  end
end