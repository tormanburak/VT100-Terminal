
.text

 
  #li $a0,3
  jal is_whitespace
  
  move $a0,$v0
  li $v0,1
  syscall
  
.include "hw3.asm"
.include "hw3_helpers.asm"
