require 'nokogiri'
require 'open-uri'

module IPS
  # Returns saved pages instead going to web
  class WebsiteTest < Website
    FILES = [
      './test/ips_empty_incoming_status.html',
      './test/ips_registration_decision_status.html',
      './test/ips_registration_status.html'
    ].freeze

    def initialize
      @status_num = -1
    end

    def get_issue_website_content(_issue_id)
      @status_num += 1
      @status_num > FILES.size && @status_num = 0

      file = open(FILES[@status_num])
      file.read.encode('utf-8')
    end
  end
end
