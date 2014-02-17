# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/reloader'
require 'rss'
require 'active_record'
require 'nokogiri'
require 'open-uri'
require './rss_getter.rb'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./RssReader.db"
)

class Rssurl < ActiveRecord::Base
  # attr_accessor :url,:title
end

get '/' do
  # 表示テスト用コード（そのうち消す）
  @rss = RSS::Parser.parse('http://somethingpg.hatenablog.com/rss')

  feeds = Rssurl.order("id").all
  puts feeds
  @ary = []
  feeds.each do |feed|
    @ary << feed
  end


  erb :index
end

post '/register_url' do
  html = params[:url].to_s

  begin
    html = open(html).read
  rescue OpenURI::HTTPError => ex
    if ex.io.status[0] = "304" then
      warn ex.message
    else
      raise ex
    end
  end

  unless html.nil?
    feeds = RSSAutoDiscovery.discover(html)
    feeds.each do |feed|
      puts feed['url']
      rss = RSS::Parser.parse(feed['url'].to_s)
      puts rss.channel.title
      Rssurl.create(:rss => feed['url'].to_s,
                    :title => rss.channel.title.to_s,
                    :url => rss.channel.link)
    end
  else
    puts "*******************can't get html**************************"
  end

  redirect '/'
end

post '/delete_url' do
end

