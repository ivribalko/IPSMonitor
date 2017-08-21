module Database
  # Operating database
  class Adapter
    def initialize
      DEBUG && ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

      ActiveRecord::Base.establish_connection(
        adapter:  DB_ADAPTER,
        username: DB_USER,
        database: DB_NAME
      )
    end

    def add_user_issue(issue_id, user_id)
      issue = Issue.find_or_create_by(id: issue_id)
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
  end
end

# begin

#     con = PG.connect :dbname => 'ips_monitor', :user => 'ivan'
#     puts con.server_version

# rescue PG::Error => e

#     puts e.message

# ensure

#     con.close if con

# end
