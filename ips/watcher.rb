module IPS
  # Worker to periodically check issue statuses
  class Watcher
    SLEEP_TIMEOUT = 120

    def initialize(website, operator, issues)
      @website = website
      @operator = operator
      @issues = issues
      @answer = Telegram::Answer.new # TODO: get instance

      @index = -1
    end

    def run
      loop do
        index = next_index

        if index
          issue_id = @issues[index]
          puts "Checking issue #{issue_id}\n" if DEBUG
          current_status = @website.get_issue_status(issue_id)

          update_issue(issue_id, current_status)
        end

        sleep(SLEEP_TIMEOUT)
      end
    end

    private

    def next_index
      issues_count = @issues.size
      max_index = issues_count - 1

      issues_count.times do
        @index += 1
        @index > max_index && @index = 0
        return @index if @issues[@index]
      end

      nil
    end

    def update_issue(issue_id, issue_data)
      issue = Database::Issue.find_by_id(issue_id)

      return if issue.nil? || issue_data.nil?

      changed = send_changed_status?(issue, issue_data) |
                send_changed_incoming?(issue, issue_data) |
                send_changed_outcoming?(issue, issue_data)

      changed && issue.update(
        status: issue_data.status,
        incoming_count: issue_data.incoming_count,
        outcoming_count: issue_data.outcoming_count
      )
    end

    def send_changed_status?(issue, issue_data)
      return false if issue.status == issue_data.status

      message = @answer.issue_updated_status(
        issue.id,
        issue_data.status
      )
      inform(issue, message)
      true
    end

    def send_changed_incoming?(issue, issue_data)
      return false if issue.incoming_count == issue_data.incoming_count

      message = @answer.issue_updated_incoming(
        issue.id,
        issue_data.last_incoming
      )
      inform(issue, message)
      true
    end

    def send_changed_outcoming?(issue, issue_data)
      return false if issue.outcoming_count == issue_data.outcoming_count

      message = @answer.issue_updated_outcoming(
        issue.id,
        issue_data.last_outcoming
      )
      inform(issue, message)
      true
    end

    def inform(issue, message)
      issue.chat_ids.each { |chat_id| @operator.send_to_chat(chat_id, message) }
    end
  end
end
