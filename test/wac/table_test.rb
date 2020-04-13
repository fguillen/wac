require "test_helper"
require "json"

class Wac::TableTest < Minitest::Test
  def test_is_table
    assert Wac::Table.new("html").is_table?
  end

  def test_is_card
    refute Wac::Table.new("html").is_card?
  end

  def test_to_json
    table_html = read_fixture("table_hugo_awards.html")

    result = Wac::Table.new(table_html).to_json
    # write_fixture("table_hugo_awards.json", result)
    assert_equal(read_fixture("table_hugo_awards.json"), result)
  end

  def test_to_hash
    table_html = read_fixture("table_hugo_awards.html")

    result = JSON.pretty_generate(Wac::Table.new(table_html).to_hash)
    assert_equal(read_fixture("table_hugo_awards.json"), result)
  end

  def test_to_json_table_small
    table_html = read_fixture("table_small.html")

    result = Wac::Table.new(table_html).to_json
    # write_fixture("table_small.json", result)
    assert_equal(read_fixture("table_small.json"), result)
  end

  def test_to_csv
    table_html = read_fixture("table_hugo_awards.html")

    result = Wac::Table.new(table_html).to_csv
    # write_fixture("table_hugo_awards.csv", result)
    assert_equal(read_fixture("table_hugo_awards.csv"), result)
  end

  def test_to_s
    table_html = read_fixture("table_small.html")

    result = Wac::Table.new(table_html).to_s
    assert_equal(read_fixture("table_small.json"), result)
  end
end
