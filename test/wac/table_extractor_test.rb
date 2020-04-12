require "test_helper"
require "json"

class Wac::TableExtractorTest < Minitest::Test
  def test_extract_table_to_json
    table_html = read_fixture("table_hugo_awards.html")

    result = JSON.pretty_generate(Wac::TableExtractor.new(table_html).extract)
    # write_fixture("table_hugo_awards.json", result)

    assert_equal(read_fixture("table_hugo_awards.json"), result)
  end

  def test_extract_table_small
    table_html = read_fixture("table_small.html")

    result = JSON.pretty_generate(Wac::TableExtractor.new(table_html).extract)
    # write_fixture("table_small.json", result)

    assert_equal(read_fixture("table_small.json"), result)
  end
end
