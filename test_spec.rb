require "socket"
require_relative "item.rb"
require_relative "ServerConn"
require_relative "clientConn"
require 'rspec/autorun'




	
 
	
	describe "SET" do
		it "set valor ok" do
		$server=ServerConn.new
		
		expect{$server.set(nil,"hola",0,0,9,"chau")}.to output("STORED\n").to_stdout
   
		end
	end
	
	describe "add NOT STORED" do
		it "add not ok" do
		$server=ServerConn.new
		
		expect{$server.set(nil,"key",0,0,9,"value")}.to output("STORED\n").to_stdout
		expect{$server.add(nil,"key",0,0,9,"value")}.to output("NOT STORED\n").to_stdout
   
		end
	end
	
	describe "add STORED" do
		it "add not ok" do
		$server=ServerConn.new
		expect{$server.add(nil,"key",0,0,9,"value")}.to output("STORED\n").to_stdout
   
		end
	end
	
describe "replace STORED" do
		it "replace ok" do
		$server=ServerConn.new
		expect{$server.set(nil,"key",0,0,9,"value")}.to output("STORED\n").to_stdout
		expect{$server.replace(nil,"key",0,0,9,"value2")}.to output("STORED\n").to_stdout
   
		end
	end
	
	describe "append STORED" do
		it "append ok" do
		$server=ServerConn.new
		expect{$server.set(nil,"key",0,0,9,"value")}.to output("STORED\n").to_stdout
		expect{$server.append(nil,"key",0,0,9,"value2")}.to output("STORED\n").to_stdout
   
		end
	end
	
	describe "prepend STORED" do
		it "prepend ok" do
		$server=ServerConn.new
		expect{$server.set(nil,"key",0,0,9,"value")}.to output("STORED\n").to_stdout
		expect{$server.prepend(nil,"key",0,0,9,"value2")}.to output("STORED\n").to_stdout
   
		end
	end
	
	describe "cas STORED" do
		it "cas ok" do
		$server=ServerConn.new
		expect{$server.set(nil,"key",0,0,9,"value")}.to output("STORED\n").to_stdout
		expect{$server.cas(nil,"key",0,0,9,1,"value2")}.to output("STORED\n").to_stdout
   
		end
	end
	
	describe "cas EXISTS" do
		it "cas EXISTS" do
		$server=ServerConn.new
		expect{$server.set(nil,"key",0,0,9,"value")}.to output("STORED\n").to_stdout
		expect{$server.cas(nil,"key",0,0,9,2,"value2")}.to output("EXISTS\n").to_stdout
   
		end
	end
	
	