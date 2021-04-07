require 'socket'
require_relative 'server_conn'

server = ServerConn.new
server.connect
server.listen
