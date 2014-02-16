require 'rubygems'
require 'open-uri'
require './rss_getter.rb'
require 'rss'

def getHTML(url)
  html = nil

  begin
    html = open(url).read
  rescue OpenURI::HTTPError => ex
    if ex.io.status[0] == "304" then
      warn ex.message
    else
      raise ex
    end
  end

  html
end

url = "http://www.lifehacker.jp/"
html = getHTML(url)
unless html.nil?
  feeds = RSSAutoDiscovery.discover(html)
  feeds.each do |feed|
    @rss = RSS::Parser.parse(feed['url'].to_s)
  end
  puts "\n\n"
else
  puts "can't get html"
end

@rss.items.each do |item|
  puts item.title
  puts item.link
end
