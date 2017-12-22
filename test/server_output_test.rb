require "./test/test_helper"

class ServerOutputTest < Minitest::Test

  def self.test_order
    :alpha
  end

  def test_hello_request_output
    response1 = Faraday.get 'http://127.0.0.1:9292/hello'
    expected1 = "Hello, World! (4)"

    assert_equal expected1, response1.body

    response2 = Faraday.get 'http://127.0.0.1:9292/hello'
    expected2 = "Hello, World! (5)"

    assert_equal expected2, response2.body

    response3 = Faraday.get 'http://127.0.0.1:9292/hello'
    expected3 = "Hello, World! (6)"

    assert_equal expected3, response3.body
  end

  def test_root_request_output
    response = Faraday.get 'http://127.0.0.1:9292/'
    expected = ["    <pre>
", "    Verb: POST
", "    Path: /
", "    Protocol: HTTP/1.1
", "    Host: 127.0.0.1
", "    Port: 9292
", "    Origin: 127.0.0.1
", "    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
", "    </pre>
", "    "]

    assert_equal expected, response.body.lines[1..-1]
  end

  def test_datetime_request_output
    response = Faraday.get 'http://127.0.0.1:9292/datetime'
    expected = (Time.now.strftime("%H:%M%p on %A, %B %-d, %Y")).to_s

    assert_equal expected, response.body
  end

  def test_a_word_search_request_output
    response1 = Faraday.get 'http://127.0.0.1:9292/word_search?word=tite'
    expected1 = "TITE is a known word"

    assert_equal expected1, response1.body

    response2 = Faraday.get 'http://127.0.0.1:9292/word_search?word=qwerty'
    expected2 = "QWERTY is not a known word"

    assert_equal expected2, response2.body
  end

  def test_shutdown_request_output
    response = Faraday.get 'http://127.0.0.1:9292/shutdown'
    expected = "Total requests: 8"

    assert_equal expected, response.body
  end
end
ServerOutputTest.test_order
