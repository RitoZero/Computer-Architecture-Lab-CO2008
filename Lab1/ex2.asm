        .data
arr:    .space 20                      # 5 word x 4 byte; dat DAU .data de canh le (alignment) 4 byte
p0:     .asciiz "Please input element 0:"
p1:     .asciiz "Please input element 1:"
p2:     .asciiz "Please input element 2:"
p3:     .asciiz "Please input element 3:"
p4:     .asciiz "Please input element 4:"
pidx:   .asciiz "Please enter index:"

        .text
main:
        la   $s0, arr                  # $s0 = dia chi co so (base address) cua mang

        # ----- Nhap mang (trai vong lap: 5 khoi giong nhau) -----
        li   $v0, 4
        la   $a0, p0
        syscall
        li   $v0, 5                    # syscall 5: read integer -> $v0
        syscall
        sw   $v0, 0($s0)               # arr[0]

        li   $v0, 4
        la   $a0, p1
        syscall
        li   $v0, 5
        syscall
        sw   $v0, 4($s0)               # arr[1]

        li   $v0, 4
        la   $a0, p2
        syscall
        li   $v0, 5
        syscall
        sw   $v0, 8($s0)               # arr[2]

        li   $v0, 4
        la   $a0, p3
        syscall
        li   $v0, 5
        syscall
        sw   $v0, 12($s0)              # arr[3]

        li   $v0, 4
        la   $a0, p4
        syscall
        li   $v0, 5
        syscall
        sw   $v0, 16($s0)              # arr[4]

        # ----- Nhap chi so k va in arr[k] -----
        li   $v0, 4
        la   $a0, pidx
        syscall
        li   $v0, 5
        syscall                        # $v0 = k

        add  $t0, $v0, $v0             # $t0 = 2k
        add  $t0, $t0, $t0             # $t0 = 4k (offset tinh bang byte)
        add  $t1, $s0, $t0             # $t1 = base + 4k
        lw   $a0, 0($t1)               # $a0 = arr[k]

        li   $v0, 1                    # syscall 1: print integer
        syscall

        li   $v0, 10                   # syscall 10: exit
        syscall