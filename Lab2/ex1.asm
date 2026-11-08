# Lab 2 - Exercise 1: Round array elements to nearest multiple of 4
# Target Architecture: MIPS32 (MARS Simulator)

.data
    array:      .space 20                   # Space for 5 integers (5 * 4 bytes)
    size:       .word 5
    prompt_in:  .asciiz "Enter element ["
    prompt_end: .asciiz "]: "
    msg_out:    .asciiz "\nProcessed array: "
    space:      .asciiz " "

.text
.globl main

main:
    la   $s0, array                         # Base address of array
    lw   $s1, size                          # Array size = 5

    # ------------------------------------------------------------------
    # PHASE 1: Input Loop
    # ------------------------------------------------------------------
    li   $t0, 0                             # Loop counter i = 0
input_loop:
    beq  $t0, $s1, process_init             # If i == 5, break loop

    # Print prompt: "Enter element [i]: "
    la   $a0, prompt_in
    li   $v0, 4
    syscall

    move $a0, $t0
    li   $v0, 1
    syscall

    la   $a0, prompt_end
    li   $v0, 4
    syscall

    # Read integer from keyboard
    li   $v0, 5
    syscall

    # Store integer into array[i]
    sll  $t1, $t0, 2                        # Offset = i * 4
    add  $t2, $s0, $t1                      # Address = base + offset
    sw   $v0, 0($t2)

    addi $t0, $t0, 1                        # i++
    j    input_loop

# ------------------------------------------------------------------
# PHASE 2: Processing & Rounding Loop
# ------------------------------------------------------------------
process_init:
    li   $t0, 0                             # Reset index i = 0

process_loop:
    beq  $t0, $s1, print_init               # If i == 5, proceed to output

    sll  $t1, $t0, 2                        # Offset = i * 4
    add  $t2, $s0, $t1                      # Address = base + offset
    lw   $t3, 0($t2)                        # Load value x = array[i]

    andi $t4, $t3, 3                        # r = x & 3 (remainder mod 4)

    # Branching based on remainder r
    beq  $t4, 0, save_element               # If r == 0, keep unchanged
    beq  $t4, 3, case_r3                    # If r == 3, add 1

case_r1_r2:
    # If r == 1 or r == 2: subtract r (round down)
    sub  $t3, $t3, $t4
    j    save_element

case_r3:
    # If r == 3: add 1 (round up to nearest multiple of 4)
    addi $t3, $t3, 1

save_element:
    sw   $t3, 0($t2)                        # Write updated value back to array
    addi $t0, $t0, 1                        # i++
    j    process_loop

# ------------------------------------------------------------------
# PHASE 3: Output Printing Loop
# ------------------------------------------------------------------
print_init:
    la   $a0, msg_out
    li   $v0, 4
    syscall

    li   $t0, 0                             # Reset index i = 0

print_loop:
    beq  $t0, $s1, exit                     # If i == 5, exit program

    sll  $t1, $t0, 2
    add  $t2, $s0, $t1
    lw   $a0, 0($t2)                        # Load array[i] to $a0

    li   $v0, 1                             # Print integer
    syscall

    la   $a0, space                         # Print space separator
    li   $v0, 4
    syscall

    addi $t0, $t0, 1                        # i++
    j    print_loop

exit:
    li   $v0, 10                            # Syscall exit
    syscall
