require 'nokogiri'
require 'csv'

class Wac::TableExtractor
  attr_reader :table_html

  def initialize(table_html)
    @table_html = table_html
  end

  def extract
    keys = extract_keys(table_html)
    table_blocks = generate_table_blocks(table_html)

    table_blocks_to_json(keys, table_blocks)
  end

  def table_blocks_to_json(keys, table_blocks)
    table_blocks.map do |row|
      row_result = {}
      keys.each_with_index do |key, index|
        row_result[key] = cell_to_json(row[index])
      end

      row_result
    end
  end

  def cell_to_json(cell_html)
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

  # def table_blocks_to_csv(keys, table_blocks)
  #   CSV.generate do |csv|
  #     csv << keys

  #     table_blocks.each do |row|
  #       csv <<
  #         row.map do |cell|
  #           clean_element(cell)
  #         end
  #     end
  #   end
  # end

  def extract_keys(table_html)
    table = Nokogiri::HTML(table_html)

    keys = table.css("thead th").map(&:text).map(&:strip)

    keys
  end

  def extract_table(html)
    doc = Nokogiri::HTML(html)
    table = doc.css("table.wikitable").first

    table.inner_html
  end

  def generate_table_blocks(table_html)
    html_table = Nokogiri::HTML(table_html)

    table_blocks = []
    row_index = 0
    column_index = 0

    table_rows = html_table.css("tbody tr")

    table_rows.each do |table_row|
      table_blocks[row_index] ||= []
      column_index = 0
      table_row.css("th, td").each do |table_cell|

        while !table_blocks[row_index][column_index].nil?
          column_index += 1
        end

        if table_cell["rowspan"]
          table_cell["rowspan"].to_i.times do |row_delta|
            table_blocks[row_index + row_delta] ||= []
            table_blocks[row_index + row_delta][column_index] = table_cell.inner_html
          end
        else
          table_blocks[row_index][column_index] = table_cell.inner_html
        end

        column_index += 1
      end

      row_index += 1
    end

    table_blocks
  end
end
