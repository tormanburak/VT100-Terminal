.data 

struct1:

	.byte 0xdd	#default bg and fg
	.byte 0x23	#highlight bg and fg
	.byte 0x2	# cursor x 
	.byte 0x4	# cursor y 
	
struct2:

	.byte 0x43 	#default bg and fg
	.byte 0xd1	#highlight bg and fg
	.byte 0x1	# cursor x 
	.byte 0x10	# cursor y 
struct3:

	.byte 0x6f 	#default bg and fg
	.byte 0xfe	#highlight bg and fg
	.byte 0x0	# cursor x 
	.byte 0x3	# cursor y 
