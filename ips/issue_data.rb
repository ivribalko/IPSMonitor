module IPS
  # Info container
  class IssueData
    attr_accessor :status,
                  :incoming_count,
                  :outcoming_count,
                  :last_incoming,
                  :last_outcoming
  end
end
