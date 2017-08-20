require 'active_record'

module Database
  # Issue database record
  class Issue < ActiveRecord::Base # TODO: fast callbacks
    before_save     :save_keys
    before_destroy  :save_keys
    after_save      :check_issues_changed
    after_destroy   :check_issues_changed

    def save_keys
      @ids = Issue.pluck(:id)
    end

    def check_issues_changed
      before = @ids
      after  = @ids = Issue.pluck(:id)
      removed = before - after
      added = after - before

      IssueList.instance.add(added)
      IssueList.instance.remove(removed)

      @ids = nil
    end
  end
end
