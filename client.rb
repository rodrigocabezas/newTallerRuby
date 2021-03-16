require "socket"
require_relative "clientConn.rb"

client = ClientConn.new()
client.connect()
client.get_command()