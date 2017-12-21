require "socket"
require "time"
require "./lib/request_formatter"
require "./lib/response_selector"

class Server
  include ResponseSelector

  def initialize
    @output  = ""
  end

  def run
    tcp_server = TCPServer.new(9292)
    @counter = 0
    loop do
      @socket = tcp_server.accept
      @request = RequestFormatter.new(@socket.readpartial(1012))
      @counter += 1

      pathfinder

      @socket.puts headers + @output
      puts ["Wrote this response:", headers, @output].join("\n")
      puts "\nResponse complete, exiting."
      @socket.close
    end
  end

  def pathfinder
    response = case @request.path
    when "/" then root
    when '/hello' then hello
    when '/datetime' then datetime
    when '/shutdown' then shutdown
    when '/word_search' then word_search(@request.parameter)
    end
    return response
  end
end
s = Server.new
s.run
