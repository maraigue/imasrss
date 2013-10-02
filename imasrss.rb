#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# アイマス公式ブログ（2013.9.21以降版）向け「非公式」RSS取得プログラム
# 書いた人：導線（http://dousen.org/）
# 初版公開日：2013年10月2日
# 
# MIT License（http://sourceforge.jp/projects/opensource/wiki/licenses%2FMIT_license）の範囲内で自由に利用を認めます。
# （作者表記を消すことがなければ、改変・組み込み等含め自由に利用いただけます。）
# 
# 動かし方
# ・Ruby（http://www.ruby-lang.org/）が動く環境を用意します。
# ・Nokogiri（http://nokogiri.org/）をインストールします。
# 　Rubygemsを用いて gem install nokogiri とするのが楽です。
# ・このスクリプトを必要に応じて書き換えます。OUTPUT_URIなど
# ・ruby imasrss.rb としてこのスクリプトを動かすと、RSS（RDF）が出力されます。

require 'nokogiri'
require 'open-uri'
require 'rss'

OUTPUT_FILE = 'index.rdf'
OUTPUT_URI = "http://dousen.org/imasrss/#{OUTPUT_FILE}" # RSSが置かれるURI。適宜変更を
PAGE_URI = 'http://idolmaster.jp/blog/'
SELECTOR_ENTRY = 'div.entryCol'  # 記事全体を囲う要素（CSSセレクタ方式で指定、以下同様）
SELECTOR_TITLE = 'h3.entryTitle' # タイトルを表す要素
SELECTOR_DATE = 'span.entryDate' # 投稿日を表す要素
SELECTOR_TEXT = 'div.entryBody'  # 本文を表す要素
SELECTOR_LINK = 'a.twitter-share-button' # Twitter投稿ボタンを表す要素（パーマリンクの取得に用います）

doc = Nokogiri::HTML(open(PAGE_URI))
entries = doc.css(SELECTOR_ENTRY).map do |ent|
  title = ent.css(SELECTOR_TITLE).inner_text
  date = ent.css(SELECTOR_DATE).inner_text
  if date =~ /\A(\d+)年(\d+)月(\d+)日\z/
    date = Time.mktime($1.to_i, $2.to_i, $3.to_i)
  else
    raise "Invalid date format: #{date}"
  end
  text = ent.css(SELECTOR_TEXT).inner_text
  link = ent.css(SELECTOR_LINK).attribute("data-url").value
  
  {:title => title, :date => date, :text => text, :link => link}
end


rss = RSS::Maker.make("1.0") do |maker|
  maker.channel.title = "THE IDOLM@STER OFFICIAL BLOG 非公式RSS@導線版"
  maker.channel.about = OUTPUT_URI
  maker.channel.description = "2013年9月21日よりリニューアルされたアイドルマスター公式ブログ（http://idolmaster.jp/blog/）の、導線（http://dousen.org/）による非公式RSSです。"
  maker.channel.link = "http://idolmaster.jp/blog/"
  
  entries.each do |e|
    item = maker.items.new_item
    item.link = e[:link]
    item.title = e[:title]
    item.date = e[:date]
    item.description = e[:text]
  end
end

open(OUTPUT_FILE, 'wb') do |f|
  f.puts rss
end
