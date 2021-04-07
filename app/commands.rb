require 'socket'
require_relative 'item'
require_relative 'message'


class Commands
  attr_accessor :port, :memory
Default = 60 * 60 * 24 * 365 * 10
  def initialize(port = 2050)
    @memory = {}
    @port = port
  end

  def print(client, line)
    client.puts(line) unless client.nil?
    puts line
  end

  def get(client, keys)
    line = ''
    keys.each do |key|
      next unless @memory[key]

      item = @memory[key]
      line += "VALUE #{key} #{item.flags}\n"
      line += "#{item.value}\n"
    end
    line += Message::MESSAGE_END
    print(client, line)
  end

  def gets(client, keys)
    line = ''
    keys.each do |key|
      next unless @memory[key]

      item = @memory[key]
      line += "VALUE #{key} #{item.flags} #{item.cas}\n"
      line += "#{item.value}\n"
    end
    line += Message::MESSAGE_END
    print(client, line)
  end

  def set(client, key, flags, ttl, newValue)
    item = Item.new(key, flags, ttl, newValue)
    @memory[key] = item
    print(client, Message::MESSAGE_STORED)
  end

  def add(client, key, flags, ttl, newValue)
    if @memory[key]
      print(client, Message::MESSAGE_NOT_STORED)
    else
      item = Item.new(key, flags, ttl, newValue)
      @memory[key] = item
      print(client,  Message::MESSAGE_STORED)
    end
  end

  def replace(client, key, flags, ttl, newValue)
    if @memory[key]
      item = Item.new(key, flags, ttl, newValue)
      @memory[key] = item
      print(client, Message::MESSAGE_STORED)
    else
      print(client, Message::MESSAGE_NOT_STORED)
    end
  end

  def append(client, key, flags, ttl, newValue)
    if @memory[key]
      item = @memory[key]

      item.ttl = ttl
      item.flags = flags
      item.value = item.value + newValue
      item.expiration = (ttl === 0 ? Time.now + Default : Time.now + ttl)
      @memory[key] = item
      print(client, Message::MESSAGE_STORED)
    else
      print(client, Message::MESSAGE_NOT_STORED)
    end
  end

  def prepend(client, key, flags, ttl, newValue)
    if @memory[key]
      item = @memory[key]

      item.ttl = ttl
      item.flags = flags
      item.value = newValue + item.value
      item.expiration = (ttl === 0 ? Time.now + Default : Time.now + ttl)
      @memory[key] = item
      print(client, Message::MESSAGE_STORED)
    else
      print(client, Message::MESSAGE_NOT_STORED)
    end
  end

  def cas(client, key, flags, ttl, cas, newValue)
    if @memory[key]
      item = @memory[key]
      if item.cas === cas

        item.ttl = ttl
        item.flags = flags
        item.cas = cas + 1
        item.value = newValue
        item.expiration = (ttl === 0 ? Time.now + Default : Time.now + ttl)
        @memory[key] = item
        print(client, Message::MESSAGE_STORED)
      else
        print(client, Message::MESSAGE_EXISTS)
      end
    else
      print(client, Message::MESSAGE_NOT_FOUND)
    end
  end
end
