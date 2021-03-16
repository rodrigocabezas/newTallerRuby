





   1 #TEST SERVER CONNECTION
  
    # Run server.rb
     # output (THE SERVER IS OPEN)
  

  2#TEST CLIENT CONNECTION
     #Run client.rb
     #output(CONNECTED)

    3#TEST SET NEW VALUE
	  #set key1 0 0 9 
	  #value1
	  #output(STORED)
	  
	 4#TEST GET OK
	 #set key1 0 0 9 value 1
	 #get key1 \
	 # output (VALUE key1 0 9
    #                            value1)

    4#TEST GETS
	#set key1 0 0 9 value 1
	#set key2 0 0 9 value2
	#gets key1,key2
	#output(VALUE key1 0 9 1
                 #value1
                 #VALUE key2 0 9 1
                 #value2)
    5#TEST GET NOT 
    # get key
    #OUTPUT(END)

    

    6#TEST ADD STORED/
    #add key 0 0 9  value
	 #output(STORED)
	 
    # TEST ADD NOT STORED
        #set key4 0 0 9 value4
		#add key4 0 0 9 value4
		#output(NOT STORED)
    

   7# TEST REPLACE
		#set key5 0 0 9 value5
		#replace key5 0 0 9 value5
		#output(STORED)
		#get key5
		#output(VALUE key2 0 8
                      #value4)
    

   8# TEST APPEND
		#set key6 0 0 9 value6
		#append key6 0 0 9 value8
		#output(STORED)
		#get key6
		#output(VALUE key2 0 18
                      #value6value8)
					  
	

    9#TEST PREPEND
		#set key7 0 0 9 value7
		#append key7 0 0 9 value9
		#output(STORED)
		#get key7
		#output(VALUE key2 0 18
                      #value9value7)
					  
	10#CAS STORED
		#set key8 0 0 9 value8
		#cas key8 0 0 9 1 value9
		#output(STORED)
		#get key8
		#output(VALUE key8 0 9 2 
                      #value9)

   
    11# TEST CAS EXISTS
		#set key9 0 0 9 value9
		#cas key8 0 0 9 1 value10
		#output(STORED)
		#cas key8 0 0 9 1 value11
		#output(EXISTS)
    
	12#TEST PURGE KEY
	  #set key10 0 10 9 value2
	  #WAIT 15 SECONDS
	  #get key10
	  #output(END)
 
  