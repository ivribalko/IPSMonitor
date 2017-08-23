require 'nokogiri'
require 'open-uri'

module IPS
  # Methods to use IPS website html
  class Website
    ISSUE_WEBSITE_PATH = 'http://www1.fips.ru/fips_servl/fips_servlet?'\
                         'DB=RUTMAP&DocNumber=%s&TypeFile=html&Delo=1'.freeze
    STATUS =        'По данным на '.freeze
    STATUS_AFTER =  'состояние делопроизводства: '.freeze
    INCOMING =      'Входящая корреспонденция'.freeze
    OUTCOMING =     'Исходящая корреспонденция'.freeze

    def get_issue_status(issue_id)
      tds = get_website_tds(issue_id)
      status_tds = td_start_with(tds, STATUS)

      return nil if status_tds[0].nil?

      incoming_tds = td_start_with(tds, INCOMING)
      outcoming_tds = td_start_with(tds, OUTCOMING)

      create_container(
        status(status_tds[0]),
        mail_status(incoming_tds[0]),
        mail_status(outcoming_tds[0])
      )
    end

    def issue_website_path(issue_id)
      ISSUE_WEBSITE_PATH % issue_id
    end

    private

    def td_start_with(tds, text)
      tds.select { |e| e.text.start_with?(text) }
    end

    def create_container(status_td, incoming_data, outcoming_data)
      result = IssueData.new
      result.status = status_td
      result.incoming_count = incoming_data[0]
      result.outcoming_count = outcoming_data[0]

      incoming_data[1] &&  result.last_incoming =  strip_sub(incoming_data[1])
      outcoming_data[1] && result.last_outcoming = strip_sub(outcoming_data[1])

      result
    end

    def status(td)
      td.text.partition(STATUS_AFTER)[2]
    end

    def mail_status(td)
      table = td.parent.parent
      count = table.children.size - 1
      last = table.search('tr')[1]

      [count, last]
    end

    def strip_sub(element)
      element.text.strip.sub!("\n", ' ')
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
