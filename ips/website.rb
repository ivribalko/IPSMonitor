require 'nokogiri'
require 'open-uri'

module IPS
	class Website
		ISSUE_WEBSITE_PATH = "http://www1.fips.ru/fips_servl/fips_servlet?DB=RUTMAP&DocNumber=%s&TypeFile=html&Delo=1"
		STATUS_DIV_START_TEXT = 'По данным на '
		INCOMING_DIV_START_TEXT = 'Входящая корреспонденция'
		OUTCOMING_DIV_START_TEXT = 'Исходящая корреспонденция'

		def initialize
			@status_num = 0
		end

		def get_issue_status(issue_id)
			html = get_issue_website_content(issue_id)
			parsed = Nokogiri::HTML html
			tds = parsed.css('td')

			status_td = tds.select {|element| element.text.start_with?(STATUS_DIV_START_TEXT)}

			if status_td[0].nil?
				return nil
			end

			incoming_td = tds.select {|element| element.text.start_with?(INCOMING_DIV_START_TEXT)}
			outcoming_td = tds.select {|element| element.text.start_with?(OUTCOMING_DIV_START_TEXT)}

			incoming_table = incoming_td[0].parent.parent
			outcoming_table = outcoming_td[0].parent.parent
			last_incoming = incoming_table.search('tr')[1]
			last_outcoming = outcoming_table.search('tr')[1]

			result = IssueData.new
			result.status = status_td[0].text
			result.incoming_count = incoming_table.children.size - 1
			result.outcoming_count = outcoming_table.children.size - 1
			result.last_incoming = last_incoming.nil? ? nil : last_incoming.text.strip().sub!("\n", " ")
      result.last_outcoming = last_outcoming.nil? ? nil : last_outcoming.text.strip().sub!("\n", " ")

			return result
		end

		def issue_website_path(issue_id)
			return ISSUE_WEBSITE_PATH % issue_id
		end

		def get_issue_website_content(issue_id)
			file = open(issue_website_path(issue_id))
			html = file.read.encode('utf-8')
		end

		def get_issue_website_content_test(issue_id)
			case @status_num
			when 0
				filepath = './test/ips_empty_incoming_status.html'
			when 1
				filepath = './test/ips_registration_decision_status.html'
			when 2
				filepath = './test/ips_registration_status.html'
			end
			
			@status_num += 1

			if @status_num > 2
				@status_num = 0
			end

			file = open(filepath)
			html = file.read.encode('utf-8')
		end
	end
end