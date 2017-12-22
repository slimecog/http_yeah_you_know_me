module ResponseSelector

  def headers
    [@status,
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "socket: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{@output.length}\r\n\r\n"].join("\r\n")
  end

  def root
    @status = "http/1.1 200 ok"
    @output = """
    <pre>
    Verb: POST
    Path: /
    Protocol: HTTP/1.1
    Host: 127.0.0.1
    Port: 9292
    Origin: 127.0.0.1
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    </pre>
    """
  end

  def hello
    @status = "http/1.1 200 ok"
    @output = "Hello, World! (#{@counter})"
  end

  def datetime
    @status = "http/1.1 200 ok"
    @output = "#{Time.now.strftime("%H:%M%p on %A, %B %-d, %Y")}"
  end

  def shutdown
    @status = "http/1.1 200 ok"
    @output = "Total requests: #{@counter}"
    @socket.puts headers + @output
    puts ["Wrote this response:", headers, @output].join("\n")
    puts "\nResponse complete : Exiting."
    @socket.close
  end

  def word_search(input)
    @status = "http/1.1 200 ok"
    if File.readlines("/usr/share/dict/words").any? { |line| input.to_s.downcase == line.chomp }
        @output = "#{input.to_s.upcase} is a known word"
      else
        @output = "#{input.to_s.upcase} is not a known word"
    end
  end

  def notfound
    @status = "http/1.1 404: Page not found"
    @output = "404: Page not found"
  end
end
