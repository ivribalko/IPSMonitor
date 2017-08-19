module IPS
  class Watcher
    def initialize(ips, issues)
      @ips = ips
      @issues = issues

      @index = -1
    end

    def run
      @active = true

      while true
        next_index = next_index()

        unless next_index.nil?
          issue_id = @issues[next_index]
          puts "Checking issue %s" % issue_id
          # puts @ips.get_issue_status(issue_id)
        end

        sleep(1)
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
  end
end