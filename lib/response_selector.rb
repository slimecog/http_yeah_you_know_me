module ResponseSelector

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
    @output = "Hello World! (#{@counter})"
  end

  def datetime
    @output = "#{Time.now.strftime("%H:%M%p on %A, %B %-m, %Y")}"
  end

  def shutdown
    @output = "Total requests: #{@counter}"
    @socket.puts headers + @output
    puts ["Wrote this response:", headers, @output].join("\n")
    puts "\nResponse complete : Exiting."
    @socket.close
  end

  def word_search(input)
    if File.readlines("/usr/share/dict/words").any? { |line| input.to_s == line.chomp }
        @output = "#{input.to_s} is a known word"
      else
        @output = "#{input.to_s} is not a known word"
    end
  end
end
