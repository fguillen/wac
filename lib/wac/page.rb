require "nokogiri"
require "open-uri"

class Wac::Page
  def initialize(url)
    @url = url
  end

  def extract
    {
      tables: tables
    }
  end

private

  def tables
    doc.css("table.wikitable").map do |nokogiri_element|
      Wac::Table.new(nokogiri_element.inner_html)
    end
  end

  def cards
  end

  def doc
    @doc ||= Nokogiri::HTML(html)
  end

  def html
    @htlm ||= URI.open(@url)
  end
end
