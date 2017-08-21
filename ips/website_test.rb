require 'nokogiri'
require 'open-uri'

module IPS
  # Returns saved pages instead going to web
  class WebsiteTest < Website
    def initialize
      @status_num = 0
    end

    def get_issue_website_content(_issue_id)
      filepath = dummy_filepath

      @status_num += 1
      @status_num > 2 && @status_num = 0

      file = open(filepath)
      file.read.encode('utf-8')
    end

    private

    def dummy_filepath
      case @status_num
      when 0
        './test/ips_empty_incoming_status.html'
      when 1
        './test/ips_registration_decision_status.html'
      when 2
        './test/ips_registration_status.html'
      end
    end
  end
end
