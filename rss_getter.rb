require 'rubygems'
require 'nokogiri'


class RSSAutoDiscovery
  RSS_XPATH = '//link[@rel="alternate"][@type="application/rss+xml"]'
  ATOM_XPATH = '//link[@rel="alternate"][@type="application/atom+xml"]'

  def self.discover(html)

    # create html from strin
    html = Nokogiri::HTML(html)

    # discover rss and atom
    @rss_feeds = discoverFeed(html,RSS_XPATH)
    @atom_feeds = discoverFeed(html,ATOM_XPATH)

    @rss_feeds
  end

  private

  def self.discoverFeed(html,feed_xpath)

    @feeds = []

    html.xpath(feed_xpath).each do |link|

      @feed_title = link.attribute('title')
      @feed_url = link.attribute('href')

      @feeds << {"title" => @feed_title,"url" => @feed_url}
    end

    @feeds
  end
end


