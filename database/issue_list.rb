module Database
  # Singleton containing issue ids
  class IssueList
    @@instance = IssueList.new
    @@issues = []

    def self.issues
      @@issues
    end

    def self.instance
      @@instance
    end

    def add(issue_ids)
      issue_ids.each do |issue_id|
        index = @@issues.index(issue_id)
        index.nil? && @@issues << issue_id
      end
    end

    def remove(issue_ids)
      issue_ids.each do |issue_id|
        index = @@issues.index(issue_id)
        index && @@issues[index] = nil
      end
    end

    private_class_method :new
  end
end
