        .data
arr:    .word 1, 2, 5, 8, 12, 44, 3, 9, 0, 10
sep:    .asciiz ", "

        .text
main:
        la   $s0, arr              # $s0 = base address
        la   $s1, sep              # $s1 = dia chi chuoi ", "

        # ----- Dao mang tai cho: 5 lan hoan doi -----
        lw   $t0, 0($s0)           # arr[0] <-> arr[9]
        lw   $t1, 36($s0)
        sw   $t1, 0($s0)
        sw   $t0, 36($s0)

        lw   $t0, 4($s0)           # arr[1] <-> arr[8]
        lw   $t1, 32($s0)
        sw   $t1, 4($s0)
        sw   $t0, 32($s0)

        lw   $t0, 8($s0)           # arr[2] <-> arr[7]
        lw   $t1, 28($s0)
        sw   $t1, 8($s0)
        sw   $t0, 28($s0)

        lw   $t0, 12($s0)          # arr[3] <-> arr[6]
        lw   $t1, 24($s0)
        sw   $t1, 12($s0)
        sw   $t0, 24($s0)

        lw   $t0, 16($s0)          # arr[4] <-> arr[5]
        lw   $t1, 20($s0)
        sw   $t1, 16($s0)
        sw   $t0, 20($s0)

        # ----- In mang: "a0, a1, ..., a9" -----
        lw   $a0, 0($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 4($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 8($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 12($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 16($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 20($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 24($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 28($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 32($s0)
        li   $v0, 1
        syscall
        move $a0, $s1
        li   $v0, 4
        syscall

        lw   $a0, 36($s0)          # phan tu cuoi: khong in dau phay sau no
        li   $v0, 1
        syscall

        li   $v0, 10
        syscall