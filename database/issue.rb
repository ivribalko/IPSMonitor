require 'active_record'

module Database
  class Issue < ActiveRecord::Base #TODO fast callbacks
    before_save     :save_keys
    before_destroy  :save_keys
    after_save      :check_issues_changed
    after_destroy   :check_issues_changed

    def save_keys
      @ids = Issue.select('id').map { |issue| issue.id }
    end

    def check_issues_changed
      before = @ids
      after  = Issue.select('id').map { |issue| issue.id }
      removed = before - after
      added = after - before

      IssueList.instance.add(added)
      IssueList.instance.remove(removed)

      @ids = nil
    end
  end
end