# -*- coding: utf-8 -*-
#require "uri"
require "open-uri"
#require "cgi"
#require "openssl"
#require "base64"
#require "digest/sha2"
#require "time"

##################
# AmazonへのAPI問合せを行うクラス
##################
class AmazonUtil
  AWS_HOST = 'ecs.amazonaws.jp'
  VERSION = '2011-08-02'
  ACCESS_KEY = 'AKIAIVYHUWROV3CHJKRQ'
  SECRET_KEY = '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'
  ASSOCIATE_TAG = 'totech-22'

  # キーワード検索をする
  def self.search_amazon(keywords)
    req = self.make_common_request
    req << "Keywords=#{URI.encode(keywords)}"
    req << "SearchIndex=Books"
    req << "Operation=ItemSearch"
  
    books = self.request_amazon(req)
    return books
  end
  
  # ItemID(ASIN)指定検索をする
  def self.lookup_amazon(item_id)
    req = self.make_common_request
    req << "ItemId=#{item_id}"
    req << "Operation=ItemLookup"

    books = self.request_amazon(req)
    return books
  end

  # 書籍リストを見やすく標準出力する
  def self.print_books(books)
    books.each do |book|
      puts book[:title]
      book[:links].each do |link|
        puts " #{link[:title]}"
      end
    end
  end

  private

  # 共通リクエストを作成する
  def self.make_common_request
    req = ["Service=AWSECommerceService","AWSAccessKeyId=#{ACCESS_KEY}","Version=#{VERSION}"]
    req << "AssociateTag=#{ASSOCIATE_TAG}"
    req << "ResponseGroup=#{CGI.escape("ItemIds,ItemAttributes,Images,Similarities")}"
    req << "Timestamp=#{CGI.escape(Time.now.getutc.iso8601)}"
    return req
  end

  # Amazon APIにリクエストを発行し、結果の書籍リストを返す
  def self.request_amazon(req)
    # リクエストを署名付きURLに変換し、リクエスト発行
    req.sort!
    message = ['GET',AWS_HOST,'/onca/xml',req.join('&')].join("\n")
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, SECRET_KEY, message)
    sign = Base64.encode64(hash).split.join
    req << "Signature=#{CGI.escape(sign)}"
    url = "http://#{AWS_HOST}/onca/xml?" + req.join('&')

    charset = nil
    html = open(url) do |f|
      charset = f.charset
      f.read
    end

    # レスポンスをパースし、書籍リストを取得
    books = []
    links = []
    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.xpath('//items/item').each do |item, i|
      book = {}
      book[:asin] = item.xpath('asin/text()').to_s
      book[:url] = item.xpath('detailpageurl/text()').to_s
      book[:title] = item.xpath('itemattributes/title/text()').to_s
      book[:image] = item.xpath('smallimage/url/text()').to_s
      source = index_or_add(books, book)
      item.xpath('similarproducts/similarproduct').each do |s|
        link = {}
        link[:from_id] = book[:asin]
        link[:from_title] = book[:title]

        to_book = {}
        to_book[:asin] = s.xpath('asin/text()').to_s
        to_book[:title] = s.xpath('title/text()').to_s
        target = index_or_add(books, to_book)

        link[:source] = source
        link[:target] = target
        link[:from_id] = book[:asin]
        link[:from_title] = book[:title]
        link[:to_id] = to_book[:asin]
        link[:to_title] = to_book[:title]
        links << link
      end
    end
    return {books: books, links: links}
  end

  # 配列に要素があればその位置を返す。なければ末尾に追加し、その位置を返す。
  def self.index_or_add(arr, elem)
    # すでに要素があればその位置を返す
    idx = arr.index(elem)
    return idx if idx
    # なければ末尾に追加し、その位置を返す
    arr << elem
    return arr.length - 1
  end
end
