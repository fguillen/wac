require "nokogiri"
require "csv"
require "json"

class Wac::Table < Wac::Element
  def initialize(table_html)
    @table_html = table_html
  end

  def to_hash
    extract
  end

  def to_json(options = nil)
    JSON.pretty_generate(to_hash)
  end

  def to_s
    to_json
  end

  def to_csv
    hash = to_hash

    CSV.generate do |csv|
      csv << hash.first.keys

      hash.each do |row|
        csv <<
          row.values.map do |cell|
            [cell].flatten.each.map do |element|
              element[:text]
            end.join(" | ")
          end
      end
    end
  end

private

  def extract
    keys = extract_keys(@table_html)
    blocks = generate_blocks(@table_html)

    blocks_to_hash(keys, blocks)
  end

  def blocks_to_hash(keys, blocks)
    blocks.map do |row|
      row_result = {}
      keys.each_with_index do |key, index|
        row_result[key] = cell_to_jshash(row[index])
      end

      row_result
    end
  end

  def cell_to_jshash(cell_html)
    doc = Nokogiri::HTML(cell_html)
    links = doc.css("a")
    result = []

    links.each do |link|
      result << {
        text: clean_element(link.inner_html),
        link: link["href"]
      }
    end

    cell_html_without_links = cell_html
    links.each do |link|
      cell_html_without_links.gsub!(link.inner_html, "")
    end

    if !clean_element(cell_html_without_links).empty?
      result << {
        text: clean_element(cell_html_without_links)
      }
    end

    result = result.first if result.size == 1

    result
  end

  def clean_element(element_html)
    Nokogiri::HTML(element_html).text.strip.gsub(/\s{2,}/, " ")
  end

  def extract_keys(table_html)
    table = Nokogiri::HTML(table_html)

    keys = table.css("tbody tr:first-of-type th").map(&:text).map(&:strip)

    keys
  end

  def extract_table(html)
    doc = Nokogiri::HTML(html)
    table = doc.css("table.wikitable").first

    table.inner_html
  end

  def generate_blocks(table_html)
    html_table = Nokogiri::HTML(table_html)

    blocks = []
    row_index = 0
    column_index = 0

    table_rows = html_table.css("tbody tr:not(:first-of-type)")

    table_rows.each do |table_row|
      blocks[row_index] ||= []
      column_index = 0
      table_row.css("th, td").each do |table_cell|

        while !blocks[row_index][column_index].nil?
          column_index += 1
        end

        if table_cell["rowspan"]
          table_cell["rowspan"].to_i.times do |row_delta|
            blocks[row_index + row_delta] ||= []
            blocks[row_index + row_delta][column_index] = table_cell.inner_html
          end
        else
          blocks[row_index][column_index] = table_cell.inner_html
        end

        column_index += 1
      end

      row_index += 1
    end

    blocks
  end
end
