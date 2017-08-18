module Database
  class Adapter
    def initialize
      ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)

      ActiveRecord::Base.establish_connection(
        adapter:  DB_ADAPTER,
        username: DB_USER,
        database: DB_NAME
      )
    end

    def add_user_issue(issue_id, user_id)
      issue = Issue.find_or_create_by(id:issue_id)
      users = issue.user_ids.nil? ? [] : issue.user_ids

      unless users.include?(user_id)
        users.push(user_id)
        issue.update(user_ids: users)
      end
    end

    def remove_user_issue(issue_id, user_id)
      issue = Issue.find(issue_id)

      unless issue.nil?
        users = issue.user_ids
        users.delete(user_id)

        if users.size == 0
          issue.destroy()
        else
          issue.update(user_ids: users)
        end
      end
    end

    def get_issue_list
      Issue.select('id')
    end

    def get_issue_list(user_id)
      issues = Issue.where("user_ids IN (ARRAY[?])", user_id)
      issues.map { |issue| issue.id }
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