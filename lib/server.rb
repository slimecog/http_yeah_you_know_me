require 'socket'

tcp_socket = TCPServer.new(9292)
counter = 0

loop do
  socket = tcp_socket.accept
  puts "Ready for a request"
  request_lines = []
  while line = socket.gets and !line.chomp.empty?
    request_lines << line.chomp
  end

  puts "Got this request:"
  puts request_lines.inspect
  counter += 1
  response = "<pre>" + request_lines.join("\n") + "</pre>"
  output = "<html><head></head><body><pre>
  Verb: POST
  Path: /
  Protocol: HTTP/1.1
  Host: 127.0.0.1
  Port: 9292
  Origin: 127.0.0.1
  Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
  </pre>Hello, World! (#{counter})</body></html>"

  headers = ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
            "socket: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  socket.puts headers
  socket.puts output
  socket.close

  puts ["Wrote this response:", headers, output].join("\n")
  puts "\nResponse complete, exiting."
end
