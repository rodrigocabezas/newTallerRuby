require 'socket'
require_relative 'client_conn'

client = ClientConn.new
client.connect
client.get_command
