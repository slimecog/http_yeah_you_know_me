require_relative "test_helper"
require_relative "../lib/server"

class ServerTest < Minitest::Test

  def test_it_exists
    s = Server.new

    assert_instance_of Server, s
  end

  def test_root_request_output
    s = Server.new
    response = Faraday.get 'http://127.0.0.1:9292/'
    expected = "<html><head></head><body><pre>
    Verb: POST
    Path: /
    Protocol: HTTP/1.1
    Host: 127.0.0.1
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre>Hello, World! (1)</body></html>"

    s.socket.close

    assert_equal expected, response

  end
end
