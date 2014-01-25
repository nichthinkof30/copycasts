require 'nokogiri'
require 'open-uri'
require 'net/http'

module Copycasts
  
  class Crawling
    TARGET_URL = 'http://railscasts.com'
    attr_accessor :page

    def initialize(options = {})
      @pages = options[:page] || maximum_page
    end

    def get_links
      casts_list = []
      puts "Start crawling..."
      for index in 1..@pages
        puts "Page :#{index}"
        target_page = Nokogiri::HTML(open(TARGET_URL + "/?type=free&page=#{index}"))
        target_page.css('.watch a:first').each do |link|
          link_without_autoplay = link['href'].to_s.sub('?autoplay=true','')
          casts_list << link_without_autoplay
        end
      end
      puts "Finish crawling."
      casts_list
    end

    def maximum_page
      target_page = Nokogiri::HTML(open(TARGET_URL + "/?type=free"))
      ret = 0
      target_page.css('.pagination a').each do |a|
        if !(a.content.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil) #not number
          if a.content.to_i > 0
            ret = a.content.to_i
          end
        end
      end
      ret
    end

    def mp4_video_links
      mp4_links = []
      get_links.each do |video_link|
        video_page = Nokogiri::HTML(open(TARGET_URL + "/" + video_link))
        link = video_page.css('.downloads li[3] a').first
        mp4_links << link.values.first
      end
      mp4_links
    end

    def download_videos
      mp4_video_links.each do |video_link|
        uri = URI.parse(video_link)
        file_name = video_link.split("/").last

        Net::HTTP.start(uri.host) do |http|
          puts "Start downloading #{file_name}..."
          response = http.get(uri.request_uri)
          open(file_name, "wb") do |file|
            file.write(response.body)
          end
        end
        puts "Downloaded successfully!"
      end
    end
  end
end
