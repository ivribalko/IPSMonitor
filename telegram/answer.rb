module Telegram
  # Telegram bot messages
  class Answer
    def initialize
      @website = IPS::Website.new # TODO
    end

    def hello(name)
      "Hello, #{name}"
    end

    def watching(issue_id)
      "Started watching issue #{issue_id}\n"\
      "#{@website.issue_website_path(issue_id)}"
    end

    def unwatched(issue_id)
      "Stopped watching issue #{issue_id}"
    end

    def no_status(issue_id)
      "Couldn't get status for issue #{issue_id}\n"\
      "#{@website.issue_website_path(issue_id)}"
    end

    def incorrect_issue_id(issue_id)
      "Issue number #{issue_id} is incorrect"
    end

    def issue_list(issues)
      "Issues: #{issues.join(', ')}"
    end

    def issue_updated_status(issue_id, status)
      "⏹ Issue #{issue_id} status updated: #{status}\n"\
      "#{@website.issue_website_path(issue_id)}"
    end

    def issue_updated_incoming(issue_id, last_incoming)
      "⬇️ Issue #{issue_id} new incoming: #{last_incoming}\n"\
      "#{@website.issue_website_path(issue_id)}"
    end

    def issue_updated_outcoming(issue_id, last_outcoming)
      "⬆️ Issue #{issue_id} new outcoming: #{last_outcoming}\n"\
      "#{@website.issue_website_path(issue_id)}"
    end

    def stopped
      'Unsupported.'
    end

    def unknown
      'Sorry?'
    end
  end
end
