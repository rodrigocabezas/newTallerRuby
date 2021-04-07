require 'socket'
require_relative 'server_conn'

class ClientConn
  attr_accessor :server, :memory, :connected, :socket

  def initialize
    @memory = {}
    @connected = false
  end

  def connect(port = 2050)
    hostname = 'localhost'
    @socket = TCPSocket.open(hostname, port)
    @connected = true
    line = @socket.gets
    puts('CONNECTED')
    puts(line.chop)
  end

  def send(line)
    @socket.write(line)
    response = @socket.recvfrom(2048)
    puts(response[0])
  end

  def listen_command(line)
    array = line.split(' ')
    command = array[0]
    key = array[1]
    case command
    when 'get', 'gets'
      array.length === 2 ? send(line) : puts("ERROR\n ")
    when 'set', 'add', 'replace', 'append', 'prepend'
      array.length === 4 ? send(line + ' ' + gets.chomp) : puts('ERROR')
    when 'cas'
      array.length === 5 ? send(line + ' ' + gets.chomp) : puts('ERROR')

    end
  end

  def get_command
    command = ''
    while command != 'quit'
      line = gets.chomp
      array = line.split(' ')
      command = array[0]
      case command
      when 'quit'
        puts('CLOSED')
      when 'get', 'gets', 'set', 'add', 'replace', 'append', 'prepend', 'cas'
        @connected ? listen_command(line) : puts('NO CONNECTION')
      else
        puts('ERROR')
      end
    end
  end
end
