class RequestFormatter
  attr_reader :path,
              :parameter

  def initialize(request)
    verb, path, protocol = request.lines[0].split
    @path, @parameter      = path.split("?word=")
    parse(request.lines)
  end

  def parse(request)
    request[1..-1].each do |line|
      key, value = line.chomp.split(': ')
      if key == 'Host'
        host, port = value.split(':')
      elsif key == 'Accept'
        accept = value
      end
    end
  end
end
