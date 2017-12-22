require "./test/test_helper"
require "./lib/server"
require "./lib/response_selector"

class ServerTest < Minitest::Test

  def test_it_exists
    s = Server.new

    assert_instance_of Server, s
  end

  def test_server_is_created_with_output_as_an_empty_string
    s = Server.new

    assert_instance_of String, s.output
    assert_empty s.output
  end

  def test_headers_output
    s = Server.new
    expected = ["date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}\r
", "socket: ruby\r
", "content-type: text/html; charset=iso-8859-1\r
", "content-length: 0\r
", "\r
"]

    assert_equal expected, s.headers.lines[1..-1]
  end

  def test_root_output
    s = Server.new
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

    assert_equal expected, s.root.lines[1..-1]
  end

  def test_hello_output
    s = Server.new

    assert_equal "Hello, World! ()", s.hello
  end

  def test_word_search_output_is_case_insensitive
    s = Server.new

    word1 = "hElLo"
    word2 = "QwErTy"

    assert_equal "HELLO is a known word", s.word_search(word1)
    assert_equal "QWERTY is not a known word", s.word_search(word2)
  end

  def test_datetime_output
    s = Server.new

    assert_instance_of String, s.datetime
    assert_equal "#{Time.now.strftime("%H:%M%p on %A, %B %-d, %Y")}", s.datetime
  end

  def test_not_found_output
    s = Server.new
    s.notfound

    assert_equal "404: Page not found", s.output
  end
end
