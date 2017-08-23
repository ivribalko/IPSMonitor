module Database
  # Operating database
  class Adapter
    def initialize(website)
      @website = website

      DEBUG && ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
      ActiveRecord::Base.establish_connection(DATABASE_URL)
    end

    def add_user_issue(issue_id, user_id)
      issue = Issue.find_by_id(issue_id)
      issue ||= create_issue(issue_id)

      users = issue.chat_ids ||= []
      return if users.include?(user_id)

      users.push(user_id)
      issue.update(chat_ids: users)
    end

    def remove_user_issue(issue_id, user_id)
      issue = Issue.find_by_id(issue_id)
      return unless issue

      users = issue.chat_ids
      users.delete(user_id)

      if users.empty?
        issue.destroy
      else
        issue.update(chat_ids: users)
      end
    end

    def issue_list
      Issue.pluck(:id)
    end

    def user_issue_list(user_id)
      issues = Issue.where('chat_ids IN (ARRAY[?])', user_id)
      issues.map(&:id)
    end

    private

    def create_issue(issue_id)
      issue_data = @website.get_issue_status(issue_id)

      # if issue_data.nil?
        Issue.create(id: issue_id)
      # else
      #   Issue.create(id: issue_id,
      #                status: issue_data.status,
      #                incoming_count: issue_data.incoming_count,
      #                outcoming_count: issue_data.outcoming_count)
      # end
    end
  end
end
