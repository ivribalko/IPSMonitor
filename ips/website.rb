require 'nokogiri'
require 'open-uri'

module IPS
  # Methods to use IPS website html
  class Website
    ISSUE_WEBSITE_PATH = "http://www1.fips.ru/fips_servl/fips_servlet?"\
                         "DB=RUTMAP&DocNumber=%s&TypeFile=html&Delo=1".freeze
    STATUS =    'По данным на '.freeze
    INCOMING =  'Входящая корреспонденция'.freeze
    OUTCOMING = 'Исходящая корреспонденция'.freeze

    def get_issue_status(issue_id)
      tds = get_website_tds(issue_id)
      status_td = get_td_start_with(tds, STATUS)

      return nil if status_td[0].nil?

      incoming_td = get_td_start_with(tds, INCOMING)
      outcoming_td = get_td_start_with(tds, OUTCOMING)

      create_container(
        status_td,
        get_mail_status(incoming_td),
        get_mail_status(outcoming_td)
      )
    end

    def get_td_start_with(tds, text)
      tds.select { |e| e.text.start_with?(text) }
    end

    def create_container(status_td, incoming, outcoming)
      result = IssueData.new
      result.status = status_td[0].text
      result.incoming_count = incoming[0]
      result.outcoming_count = outcoming[0]

      incoming[1] &&  result.last_incoming =  strip_sub(incoming[1])
      outcoming[1] && result.last_outcoming = strip_sub(outcoming[1])

      result
    end

    def get_mail_status(td)
      table = td[0].parent.parent
      count = table.children.size - 1
      last = table.search('tr')[1]

      [count, last]
    end

    def strip_sub(element)
      element.text.strip.sub!("\n", ' ')
    end

    def issue_website_path(issue_id)
      ISSUE_WEBSITE_PATH % issue_id
    end

    def get_website_tds(issue_id)
      html = get_issue_website_content(issue_id)
      parsed = Nokogiri::HTML html
      parsed.css('td')
    end

    def get_issue_website_content(issue_id)
      file = open(issue_website_path(issue_id))
      file.read.encode('utf-8')
    end
  end
end
