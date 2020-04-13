require "test_helper"
require "json"

class Wac::PageTest < Minitest::Test
  def test_country_codes_article
    url = "https://en.wikipedia.org/wiki/ISO_3166-1"

    result =
      VCR.use_cassette("country_codes") do
        Wac::Page.new(url).extract
      end

    result = JSON.pretty_generate(result)
    write_fixture("article_country_codes.json", result)
    assert_equal(read_fixture("article_country_codes.json"), result)
  end
end
