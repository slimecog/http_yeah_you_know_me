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
response = "hello world (#{counter})"
output = "<html><head></head><body>#{response}</body></html>"
headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "socket: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{output.length}\r\n\r\n"].join("\r\n")
socket.puts headers
socket.puts output
end
puts ["Wrote this response:", headers, output].join("\n")
socket.close
puts "\nResponse complete, exiting."
