require "socket"
require_relative "item.rb"

class ServerConn
    attr_accessor :port
    attr_accessor :memory
    attr_accessor :server
    
    def initialize(port = 2050)
      @port = port
      @memory = {}
    end

    
    def listenClient(client, line)
      array = line.split(" ")
      command = array[0]
      case command
        when "get"
          get(client,array[1].split(","))
        when "gets"
          gets(client,array[1].split(","))
        when "set"
          set(client,array[1],array[2],Integer(array[3]),Integer(array[4]), array[5])
        when "add"
          add(client,array[1],array[2],Integer(array[3]),Integer(array[4]), array[5])
        when "replace"
          replace(client,array[1],array[2],Integer(array[3]),Integer(array[4]), array[5])
        when "append"
          append(client,array[1],array[2],Integer(array[3]),Integer(array[4]),array[5])
        when "prepend"
          prepend(client,array[1],array[2],Integer(array[3]),Integer(array[4]), array[5])
        when "cas"
          cas(client,array[1],array[2],Integer(array[3]),Integer(array[4]), Integer(array[5]), array[6])
      end
    end

  def connect()
      @server = TCPServer.open(@port)    
      puts("THE SERVER IS OPEN")
    end

 
    def listen()
      loop {                           
        Thread.start(@server.accept) do |client|
          client.puts(Time.now.ctime)   
          while line = client.recv(200)
            purgeExpiryKey()
            puts line
            listenClient(client,line)
          end
        end
      }
    end

      def purgeExpiryKey()
      time = Time.now
      @memory.each do |key, item|
        if item.expiration < time
          @memory.delete(key)
          puts "DELETE #{item.value}"
        end
      end
    end
	
	
    def print (client, line)
      if client != nil 
        client.puts(line)
      end
      puts line
    end
  
    
    def get(client,keys)
      line = ""
      keys.each do |key|
        if @memory[key]
          item = @memory[key]
          line += "VALUE #{key} #{item.flags} #{item.bytes}\n"
          line += "#{item.value}\n"
        end
      end
      line += "END\n"
      print(client, line)
    end

    
    def gets(client,keys)
      line = ""
      keys.each do |key|
        if @memory[key]
          item = @memory[key]
          line += "VALUE #{key} #{item.flags} #{item.bytes} #{item.cas}\n"
          line += "#{item.value}\n"
        end
      end
      line += "END\n"
      print(client, line)
    end
  
    
    def set(client,key, flags, ttl, bytes, newValue)
      item = Item.new(key,flags,ttl,bytes,newValue)
      @memory[key] = item
      print(client, "STORED")
    end

    
    def add(client,key, flags, ttl, bytes, newValue)
      if @memory[key]
        print(client,  "NOT STORED")
      else 
        item = Item.new(key,flags,ttl,bytes,newValue)
        @memory[key] = item
        print(client,  "STORED")
      end
    end

    
    def replace(client,key, flags, ttl, bytes, newValue)
      if @memory[key] 
        item = Item.new(key,flags,ttl,bytes,newValue)
        @memory[key] = item
        print(client,  "STORED")
      else
        print(client,  "NOT STORED")
      end
    end

    
    def append(client,key, flags, ttl, bytes, newValue)
      if @memory[key] 
        item = @memory[key]
        item.bytes = item.bytes + bytes
        item.ttl = ttl
        item.flags = flags
        item.value = item.value + newValue
        ttl === 0 ? item.expiration = Time.now + (60*60*24*365*10): item.expiration = Time.now + ttl
        @memory[key] = item
        print(client,  "STORED")
      else
        print(client,  "NOT STORED")
      end
    end

    
    def prepend(client, key, flags, ttl, bytes, newValue)
      if @memory[key] 
        item = @memory[key]
        item.bytes = item.bytes + bytes
        item.ttl = ttl
        item.flags = flags
        item.value = newValue+ item.value
        ttl === 0 ? item.expiration = Time.now + (60*60*24*365*10): item.expiration = Time.now + ttl
        @memory[key] = item
        print(client,  "STORED")
      else
        print(client,  "NOT STORED")
      end
    end

    
    def cas(client, key, flags, ttl, bytes, cas, newValue)
      if @memory[key] 
        item = @memory[key]
        if item.cas === cas 
          item.bytes = bytes
          item.ttl = ttl
          item.flags = flags
          item.cas = cas + 1
          item.value = newValue
          ttl === 0 ? item.expiration = Time.now + (60*60*24*365*10): item.expiration = Time.now + ttl
          @memory[key] = item
          print(client, "STORED")
        else 
          print(client, "EXISTS")
        end
      else
        print(client, "NOT_FOUND")
      end
    end
  end
  