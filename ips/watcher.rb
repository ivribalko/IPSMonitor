module IPS
  class Watcher
    SLEEP_TIMEOUT = 30

    def initialize(website, operator, issues)
      @website = website
      @operator = operator
      @issues = issues
      @answer = Telegram::Answer.new #TODO get instance

      @index = -1
    end

    def run
      @active = true

      while true
        next_index = next_index()

        unless next_index.nil?
          issue_id = @issues[next_index]
          puts "Checking issue %s" % issue_id
          current_status = @website.get_issue_status(issue_id)

          update_issue(issue_id, current_status)
        end

        sleep(SLEEP_TIMEOUT)
      end
    end

    def stop
      @active = false
    end

    def next_index
      max_index = @issues.size - 1

      for i in 0..max_index
        @index += 1

        if @index > max_index
          @index = 0
        end

        if @issues[@index] != nil
          return @index
        end
      end

      return nil
    end

    def update_issue(issue_id, issue_data)
      if issue_data.nil?
        return
      end

      issue = Database::Issue.find_by_id(issue_id)

      if issue.nil?
        return
      end

      if issue.status != issue_data.status
        message = @answer.issue_updated_status(issue_id, issue_data.status)
        inform(issue, message)

        issue.update(status:issue_data.status)
      end
      
      if issue.incoming_count != issue_data.incoming_count
        message = @answer.issue_updated_incoming(issue_id, issue_data.last_incoming)
        inform(issue, message)

        issue.update(incoming_count:issue_data.incoming_count)
      end
      
      if issue.outcoming_count != issue_data.outcoming_count
        message = @answer.issue_updated_outcoming(issue_id, issue_data.last_outcoming)
        inform(issue, message)

        issue.update(outcoming_count:issue_data.outcoming_count)
      end
    end

    def inform(issue, message)
      issue.chat_ids.each { |chat_id|
          @operator.send_to_chat(chat_id, message)
      }
    end
  end
end