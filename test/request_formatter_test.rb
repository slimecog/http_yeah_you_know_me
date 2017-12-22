require "./test/test_helper"
require "./lib/request_formatter"

class RequestFormatterTest < Minitest::Test

  REQUEST = "GET /word_search?word=tite HTTP/1.1\r\nHost: 127.0.0.1:9292\r\nConnection: keep-alive\r\nCache-Control: no-cache\r\nUser-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36\r\nPostman-Token: a9333323-ab3f-8cfc-059b-6938eedde66b\r\nAccept: */*\r\nAccept-Encoding: gzip, deflate, br\r\nAccept-Language: en-US,en;q=0.9\r\n\r\n"

  def test_it_exists
    rf = RequestFormatter.new(REQUEST)

    assert_instance_of RequestFormatter, rf
  end

  def test_it_is_created_with_attributes
    rf = RequestFormatter.new(REQUEST)

    assert_equal "/word_search", rf.path
    assert_equal "tite", rf.parameter
  end
end
