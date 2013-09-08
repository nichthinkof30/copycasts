require 'nokogiri'

module CopyCasts
  class RailsCast
    TARGET_URL = 'http://railscasts.com'
    attr_accessor :type, :pages

    def initialize(type, pages)
      @type = type
      @pages = pages
    end

    def get_links
      casts_list = []
      max = self.maximum_page
      if @pages <= max
        for index in 1..@pages
          target_page = Nokogiri::HTML(open(TARGET_URL + "/?type=#{@type}&page=#{index}"))
          target_page.css('.watch a:first').each do |link|
            link_without_autoplay = link.to_s.sub('?autoplay=true','')
            casts_list << link_without_autoplay
          end
        end
      else
        puts "Exceed limitation!"
      end
      casts_list
    end

    def maximum_page
      target_page = Nokogiri::HTML(open(TARGET_URL + "/?type=#{@type}"))
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
  end
end