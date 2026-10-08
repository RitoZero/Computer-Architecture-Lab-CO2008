    	.data
prompt: .asciiz "Enter your name: "
hello:  .asciiz "Hello, "
excl:   .asciiz "!"
name:   .space 64                 

        .text
main:
        li   $v0, 4               
        la   $a0, prompt
        syscall

        li   $v0, 8               
        la   $a0, name            
        li   $a1, 64              
        syscall

        li   $v0, 4
        la   $a0, hello
        syscall

        li   $v0, 4
        la   $a0, name
        syscall

        li   $v0, 4
        la   $a0, excl
        syscall

        li   $v0, 10             
        syscall