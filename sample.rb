require 'nokogiri'

class RSSAutoDiscovery
    # xpath for feed
    RSS_xpath  = '//link[@rel="alternate"][@type="application/rss+xml"]'
    Atom_xpath = '//link[@rel="alternate"][@type="application/atom+xml"]'

    def discover_rss(html)

        # create html from string
        html = Nokogiri::HTML(html)

        # discover rss and atom
        @rss_feeds = discoverFeed(html, RSS_xpath)
        @atom_feeds = discoverFeed(html, Atom_xpath)

        return @rss_feeds + @atom_feeds
    end

    def discoverFeed(html, feed_xpath)

        # feed list
        @feeds = Array.new

        # discover feed
        html.xpath(feed_xpath).each do |link|

            # get feed title and url
            @feed_title = link.attribute("title")
            @feed_url = link.attribute("href")

            # push hash to array
            @feeds << {"title" => @feed_title, "url" => @feed_url}
        end

        return @feeds
    end
end

require 'open-uri'

# HTMLを取得する
class Rssurl
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

    return html
end
end


# メイン
urls = Array.new
urls << "http://d.hatena.ne.jp/yukihir0/"
urls << "http://www.lifehacker.jp/"

urls.each do |url|
    html = getHTML(url)

    unless html.nil?
        feeds = RSSAutoDiscovery.new
        feeds = feeds.discover_rss(html)

        puts "--- #{url} ---"
        feeds.each do |feed|
            puts "#{feed['title']} : #{feed['url']}"
        end
        (url.length+8).times {
            print "-"
        }
        puts "\n\n"
    else
        puts "can't get html"
    end

end
