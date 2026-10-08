        .data
pa:     .asciiz "Insert a: "
pb:     .asciiz "Insert b: "
pc:     .asciiz "Insert c: "
pd:     .asciiz "Insert d: "
outF:   .asciiz "F = "
outR:   .asciiz ", remainder "

        .text
main:
        # ----- Nhap a, b, c, d theo dung thu tu -----
        li   $v0, 4
        la   $a0, pa
        syscall
        li   $v0, 5
        syscall
        move $s0, $v0              # $s0 = a

        li   $v0, 4
        la   $a0, pb
        syscall
        li   $v0, 5
        syscall
        move $s1, $v0              # $s1 = b

        li   $v0, 4
        la   $a0, pc
        syscall
        li   $v0, 5
        syscall
        move $s2, $v0              # $s2 = c

        li   $v0, 4
        la   $a0, pd
        syscall
        li   $v0, 5
        syscall
        move $s3, $v0              # $s3 = d

        # ----- Tu so: (a+10)(b-d)(c-2a) -----
        addi $t0, $s0, 10          # $t0 = a + 10
        sub  $t1, $s1, $s3         # $t1 = b - d
        add  $t2, $s0, $s0         # $t2 = 2a
        sub  $t2, $s2, $t2         # $t2 = c - 2a
        mul  $t3, $t0, $t1         # $t3 = (a+10)(b-d)
        mul  $t3, $t3, $t2         # $t3 = tu so

        # ----- Mau so: a+b+c -----
        add  $t4, $s0, $s1         # $t4 = a + b
        add  $t4, $t4, $s2         # $t4 = a + b + c

        # ----- Chia -----
        div  $t3, $t4              # LO = thuong, HI = so du
        mflo $t5                   # $t5 = quotient
        mfhi $t6                   # $t6 = remainder

        # ----- In "F = q, remainder r" -----
        li   $v0, 4
        la   $a0, outF
        syscall
        li   $v0, 1
        move $a0, $t5
        syscall
        li   $v0, 4
        la   $a0, outR
        syscall
        li   $v0, 1
        move $a0, $t6
        syscall

        li   $v0, 10
        syscall