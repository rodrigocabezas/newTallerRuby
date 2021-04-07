require 'socket'
require_relative 'commands'

class ServerConn
  attr_accessor :port, :memory, :server

  def initialize(port = 2050)
    @port = port
    @memory = {}
    @c = Commands.new
  end

  def listen_client(client, line)
    array = line.split(' ')
    command = array[0]
    case command
    when 'get'
      @c.get(client, array[1].split(','))
    when 'gets'
      @c.gets(client, array[1].split(','))
    when 'set'
      @c.set(client, array[1], array[2], array[3].to_i, array[4])
    when 'add'
      @c.add(client, array[1], array[2], array[3].to_i, array[4])
    when 'replace'
      @c.replace(client, array[1], array[2], array[3].to_i, array[4])
    when 'append'
      @c.append(client, array[1], array[2], array[3].to_i, array[4])
    when 'prepend'
      @c.prepend(client, array[1], array[2], array[3].to_i, array[4])
    when 'cas'
      @c.cas(client, array[1], array[2], array[3].to_i, array[4].to_i, array[5])
    end
  end

  def connect
    @server = TCPServer.open(@port)
    puts('THE SERVER IS OPEN')
  end

  def listen
    loop do
      Thread.start(@server.accept) do |client|
        client.puts(Time.now.ctime)
        while line = client.recv(200)
          purge_expiry_key
          puts line
          listen_client(client, line)
        end
      end
    end
  end

  def purge_expiry_key
    time = Time.now
    @memory.each do |key, item|
      if item.expiration < time
        @memory.delete(key)
        puts "DELETE #{item.value}"
      end
    end
  end
end
