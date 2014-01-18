require 'nokogiri'
require 'open-uri'

class RailsCast
  TARGET_URL = 'http://railscasts.com'
  attr_accessor :pages

  def initialize(options = {})
    @pages = options[:pages]
  end

  def get_links
    casts_list = []
    # max = self.maximum_page
    # if @pages <= max
    for index in 1..@pages
      target_page = Nokogiri::HTML(open(TARGET_URL + "/?type=free&page=#{index}"))
      target_page.css('.watch a:first').each do |link|
        link_without_autoplay = link['href'].to_s.sub('?autoplay=true','')
        casts_list << link_without_autoplay
      end
    end
    # else
    #   puts "Exceed limitation!"
    # end
    puts maximum_page.inspect
    
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

  end
end


