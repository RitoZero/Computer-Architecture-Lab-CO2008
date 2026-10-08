        .data
prompt: .asciiz "Please enter a positive integer less than 16: "
outmsg: .asciiz "Its binary form is: "

        .text
main:
        # ----- Nhap n -----
        li   $v0, 4
        la   $a0, prompt
        syscall
        li   $v0, 5
        syscall
        move $s0, $v0              # $s0 = n

        li   $v0, 4
        la   $a0, outmsg
        syscall

        # ----- Bit 3: n / 8 -----
        li   $t1, 8
        div  $s0, $t1
        mflo $a0                   # b3
        mfhi $s0                   # phan con lai
        li   $v0, 1
        syscall

        # ----- Bit 2: r / 4 -----
        li   $t1, 4
        div  $s0, $t1
        mflo $a0                   # b2
        mfhi $s0
        li   $v0, 1
        syscall

        # ----- Bit 1: r / 2 -----
        li   $t1, 2
        div  $s0, $t1
        mflo $a0                   # b1
        mfhi $s0
        li   $v0, 1
        syscall

        # ----- Bit 0: so du cuoi cung -----
        move $a0, $s0              # b0
        li   $v0, 1
        syscall

        li   $v0, 10
        syscall