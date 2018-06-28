.data
part1cSpace: .space 40
newline: .asciiz "\n"
space: .asciiz "  "
part1aStr: .asciiz "part1a"
part1bStr: .asciiz "part1b"
part1cStr: .asciiz "part1c"
part1dStr:.asciiz "part1d"
part2eStr: .asciiz "part2e"
part2fStr: .asciiz "part2f"
part2gStr: .asciiz "part2g"
part2hStr: .asciiz "part2h"
part2iStr: .asciiz "part2i"
part2jStr: .asciiz "part2j"
part2kStr: .asciiz "part2k"
part3oStr: .asciiz "part3o"
part1cTest1Str: .ascii "Hi CSE 220...."
part1cSpaceNoChange: .space 40
part1dTest1Str: .asciiz "Hi CSE 220...."
part1dTest2Str: .asciiz "HiCSE220....\0"
part1dTest3Str: .asciiz " HiCSE220...."
part1dTest4Str: .asciiz "H\niCSE220...."
part1dTest5Str: .asciiz "HiCSE220....\n"
part2kTestStr: .asciiz "st ring "
part2kTestStr2: .asciiz "st ring "





.macro print_str(%label)
la $a0, %label
li $v0, 4
syscall
.end_macro

.macro print_struct(%label)
la $a0,%label
move $a1,$a0

lbu $t0,0($a1)
move $a0,$t0
li $v0,34
syscall
print_str(space)
addi $a1,$a1,1
lbu $t0,0($a1)
move $a0,$t0
li $v0,34
syscall
print_str(space)
addi $a1,$a1,1
lbu $t0,0($a1)
move $a0,$t0
li $v0,34
syscall
print_str(space)
addi $a1,$a1,1
lbu $t0,0($a1)
move $a0,$t0
li $v0,34
syscall

.end_macro
.text
part1A:
	
	print_str(part1aStr)
	print_str(newline)

	li $a0 , 1
	jal is_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	

	print_str(newline)

	li $a0 , ' '
	jal is_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	print_str(newline)

	
	li $a0 , '\n'
	jal is_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	
	print_str(newline)

	
	li $a0 , '\0'
	jal is_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	print_str(newline)

	
	li $a0 , 's'
	jal is_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	
	print_str(newline)
	
	li $a0 , 'h'
	jal is_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall


part1b:
	print_str(newline)
	print_str(part1bStr)
    	print_str(newline)
	
	li $a0 , 's'
	li $a1 , 's'
	jal cmp_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	

	print_str(newline)

	li $a0 , '\n'
	li $a1 , ' '
	jal cmp_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	
	print_str(newline)

	
	li $a0 , '\0'
	li $a1 , '\n'
	jal cmp_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	print_str(newline)

	
	li $a0 , '\0'
	li $a1 , '\0'
	jal cmp_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	print_str(newline)
	
	li $a0 , '\n'
	li $a1 , ' '
	jal cmp_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	print_str(newline)

	
	li $a0 , 's'
	li $a1 , '\n'
	jal cmp_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	print_str(newline)

	
	li $a0 , '\n'
	li $a1 , 5
	jal cmp_whitespace
	
	move $a0 ,$v0
	li $v0, 1
	syscall


part1c:
	print_str(newline)
	print_str(part1cStr)
	print_str(newline)
	
	la $a0 , part1cTest1Str
	la $a1 , part1cSpaceNoChange
	li $a2 , 15
	jal strcpy
	print_str(part1cSpaceNoChange)
	print_str(newline)
	
		
	la $a0 , part1cTest1Str
	la $a1 , part1cTest1Str
	li $a2 , 10
	jal strcpy
	print_str(part1cTest1Str)
	print_str(newline)
	
		
	la $a0 , part1cStr
	la $a1 , part1cSpace
	li $a2 ,3
	jal strcpy
	print_str(part1cSpace)
	print_str(newline)
	
	
		
	la $a0 , part1cTest1Str
	la $a1 , part1cSpace
	li $a2 , 10
	jal strcpy
	print_str(part1cSpace)
	print_str(newline)

	
		
	la $a0 , part1cTest1Str
	la $a1 , part1cSpace
	li $a2 , 15
	jal strcpy
	print_str(part1cSpace)
	print_str(newline)

part1d:
	
	print_str(part1dStr)	
	print_str(newline)	
	la $a0 , part1dTest1Str
	jal strlen
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	
	print_str(newline)
	
	la $a0 , part1dTest2Str
	jal strlen
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	
	print_str(newline)
	
	la $a0 , part1dTest3Str
	jal strlen
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	
	print_str(newline)
	
	la $a0 , part1dTest4Str
	jal strlen
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	
	print_str(newline)
	
	la $a0 , part1dTest5Str
	jal strlen
	
	move $a0 ,$v0
	li $v0, 1
	syscall
	
	
	print_str(newline)
	
part2e:	
	
	print_str(part2eStr)
	print_str(newline)
	
	la $a0,struct1
	li $a1,0x06
	li $a2,0	#cate
	li $a3,0	#mode
	
	jal set_state_color
	
	print_struct(struct1)
	print_str(newline)
	
	la $a0,struct2
	li $a1,0x06
	li $a2,0	#cate
	li $a3,1	#mode
	
	jal set_state_color
	
	print_struct(struct2)
	print_str(newline)
	
	la $a0,struct3
	li $a1,0x06
	li $a2,1	#cate
	li $a3,2	#mode
	
	jal set_state_color
	
	print_struct(struct3)
	print_str(newline)
	
	
part2f:
	print_str(part2fStr)
	print_str(newline)
	
	la $a0,struct1
	li $a1,'c'
	jal save_char
	
part2g:
	print_str(part2gStr)
	print_str(newline)
	la $a0,struct1
	li $a1,1
	jal reset
part2h:
	print_str(part2hStr)
	print_str(newline)
	li $a0,0x2
	li $a1,0x4
	li $a2,0xd3
	jal clear_line
	
part2i:
	print_str(part2iStr)
	print_str(newline)
	la $a0,struct1
	li $a1,0x2
	li $a2,0x6
	li $a3,0
	jal set_cursor
	print_struct(struct1)
	

part2j:
	print_str(part2jStr)
	print_str(newline)
	la $a0,struct1
	li $a1,'h'
	jal move_cursor
part2k:
	print_str(part2kStr)
	print_str(newline)

	la $a0,part2kTestStr
	la $a1,part2kTestStr2
	
	jal mmio_streq
	
	move $a0,$v0
	li $v0,1
	syscall
	
	print_str(newline)
part3o:
	print_str(part3oStr)
	print_str(newline)
	li $a0,0x33
	la $a1,highlight_dictionary
	jal highlight_all
	
	li $v0,10
	syscall
.include "hw3_helpers.asm"
.include "hw3.asm"
.include "hw3Structs.asm"
.include "hw3_dict.asm"
