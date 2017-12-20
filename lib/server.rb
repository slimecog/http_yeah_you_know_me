require 'socket'

class Server

  def initialize
    @output = ""
  end

  def run
    tcp_server = TCPServer.new(9292)
    @counter = 0
    loop do
      socket = tcp_server.accept
      puts "Ready for a request"
      request_lines = []
      while line = socket.gets and !line.chomp.empty?
        request_lines << line.chomp
      end

      puts "Got this request:"
      @counter += 1
      puts request_lines.inspect

      if parse(request_lines) == "/hello"
        @output = self.hello
      elsif parse(request_lines) == "/datetime"
        @output = datetime
      elsif parse(request_lines) == "/"
        @output = root
      elsif parse(request_lines) == "/shutdown"
        @output = shutdown
        socket.puts headers
        socket.puts @output
        puts ["Wrote this response:", headers, @output].join("\n")
        puts "\nResponse complete : Exiting."
        socket.close
      else
        @output = "404: Page not found"
      end

      socket.puts headers
      socket.puts @output
      puts ["Wrote this response:", headers, @output].join("\n")
      puts "\nResponse complete, exiting."
      socket.close
    end
  end

  def headers
    ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "socket: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
  end

  def root
    @output = "<html><head></head><body><pre>
    Verb: POST
    Path: /
    Protocol: HTTP/1.1
    Host: 127.0.0.1
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre></body></html>"
  end

  def hello
    "Hello World! (#{@counter})"
  end

  def datetime
    "#{Time.now.strftime("%H:%M%p on %A, %B %-m, %Y")}"
  end

  def shutdown
    "Total requests: #{@counter}"
  end

  def parse(input)
    input[0].split[1]
  end
end
s = Server.new
s.run
