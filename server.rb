require "socket"
require_relative "ServerConn.rb"

server = ServerConn.new()
server.connect()
server.listen()