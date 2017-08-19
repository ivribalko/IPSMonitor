require 'nokogiri'
require 'open-uri'

module IPS
	class Website
		ISSUE_WEBSITE_PATH = "http://www1.fips.ru/fips_servl/fips_servlet?DB=RUTMAP&DocNumber=%s&TypeFile=html&Delo=1"
		STATUS_DIV_START_TEXT = 'По данным на '

		def get_issue_status(issue_id)
			html = get_issue_website_content(issue_id)
			parsed = Nokogiri::HTML html
			tds = parsed.css('td')

			status_div = tds.select {|element| element.text.start_with?(STATUS_DIV_START_TEXT)}

			unless status_div[0].nil?
	      status_div[0].text
	    end
		end

		def get_issue_website_content(issue_id)
			file = open(ISSUE_WEBSITE_PATH % issue_id)
			html = file.read.encode('utf-8')
		end
	end
end