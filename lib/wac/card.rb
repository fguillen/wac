require "nokogiri"
require "csv"
require "json"

class Wac::Card < Wac::Element
  def initialize(card_html)
    @card_html = card_html
  end

  def to_hash
    extract
  end
end
