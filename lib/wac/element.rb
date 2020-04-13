require 'nokogiri'
require 'csv'

class Wac::Element
  def is_table?
    self.is_a? Wac::Table
  end

  def is_card?
    self.is_a? Wac::Card
  end
end
