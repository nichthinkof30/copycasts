require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'progressbar'

module Copycasts
  
  class Crawling
    TARGET_URL = 'http://railscasts.com'

    def initialize(options = {})
      @pages = options[:page] || maximum_page
    end

    def get_links
      casts_list = []
      puts "Start crawling page "

      for index in 1..@pages
        print "#{index}"
        print ", " if index != @pages
        target_page = Nokogiri::HTML(open(TARGET_URL + "/?type=free&page=#{index}"))
        target_page.css('.watch a:first').each do |link|
          link_without_autoplay = link['href'].to_s.sub('?autoplay=true','')
          casts_list << link_without_autoplay
        end
      end
      puts "\n"
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
      count = 0
      mp4_links = []
      page_links = get_links
      
      puts "Start crawling for download target"
      progress = ProgressBar.new("Crawling:", page_links.length)

      page_links.each do |video_link|
        video_page = Nokogiri::HTML(open(TARGET_URL + "/" + video_link))
        link = video_page.css('.downloads li[3] a').first
        mp4_links << link.values.first
        count += 1
        progress.set(count)
      end
      puts "\n"
      mp4_links
    end

    def download_videos
      downloaded = 0
      mp4_video_links.each do |video_link|
        count = 0
        uri = URI.parse(video_link)
        file_name = video_link.split("/").last

        Net::HTTP.start(uri.host) do |http|
          response = http.request_head(uri.request_uri)
          progress = ProgressBar.new("#{downloaded} downloaded", response['content-length'].to_i)
          File.open(file_name, "wb") do |file|
            http.get(uri.request_uri) do |request_return|
              file.write(request_return)
              count += request_return.length
              progress.set(count)
            end
          end
        end
        downloaded += 1
      end

      puts "Downloaded all files successfully!"
    end
  end
end
