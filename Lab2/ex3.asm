# Lab 2 - Exercise 3: Find second largest element and all its indexes

.data
    array:          .space 40                   # Array of 10 integers (10 * 4 bytes)
    size:           .word 10
    prompt:         .asciiz "Please insert a element: "
    msg_no_second:  .asciiz "No second largest element exists.\n"
    msg_res1:       .asciiz "Second largest value is "
    msg_res2:       .asciiz ", found in index "
    comma:          .asciiz ", "
    newline:        .asciiz "\n"

.text
.globl main

main:
    la   $s0, array                             # Base address of array
    lw   $s1, size                              # Array size = 10

    # ------------------------------------------------------------------
    # PHASE 1: Input 10 elements from keyboard
    # ------------------------------------------------------------------
    li   $t0, 0                                 # Loop index i = 0
input_loop:
    beq  $t0, $s1, process_init                 # If i == 10, start processing

    la   $a0, prompt                            # Print prompt
    li   $v0, 4
    syscall

    li   $v0, 5                                 # Read integer
    syscall

    sll  $t1, $t0, 2                            # Offset = i * 4
    add  $t2, $s0, $t1                          # Address = base + offset
    sw   $v0, 0($t2)                            # Store into array[i]

    addi $t0, $t0, 1                            # i++
    j    input_loop

# ------------------------------------------------------------------
# PHASE 2: Find max1 and max2 (Two-pass logic)
# ------------------------------------------------------------------
process_init:
    li   $s2, 0x80000000                        # max1 = -2^31 (MIN_INT)
    li   $s3, 0x80000000                        # max2 = -2^31 (MIN_INT)
    li   $t0, 0                                 # Loop index i = 0

find_max_loop:
    beq  $t0, $s1, check_second_max             # If i == 10, proceed to output

    sll  $t1, $t0, 2
    add  $t2, $s0, $t1
    lw   $t3, 0($t2)                            # x = array[i]

    # Check if x > max1
    ble  $t3, $s2, check_max2
    move $s3, $s2                               # max2 = max1
    move $s2, $t3                               # max1 = x
    j    next_elem

check_max2:
    # Check if x < max1 AND x > max2
    beq  $t3, $s2, next_elem                    # If x == max1, ignore
    ble  $t3, $s3, next_elem                    # If x <= max2, ignore
    move $s3, $t3                               # max2 = x

next_elem:
    addi $t0, $t0, 1                            # i++
    j    find_max_loop

# ------------------------------------------------------------------
# PHASE 3: Print result and matching indexes
# ------------------------------------------------------------------
check_second_max:
    li   $t4, 0x80000000
    beq  $s3, $t4, print_no_second              # If max2 is still MIN_INT, no second max exists

    # Print "Second largest value is <max2>, found in index "
    la   $a0, msg_res1
    li   $v0, 4
    syscall

    move $a0, $s3                               # Print max2 value
    li   $v0, 1
    syscall

    la   $a0, msg_res2
    li   $v0, 4
    syscall

    # Pass 2: Loop to print all indexes of max2
    li   $t0, 0                                 # Index i = 0
    li   $t5, 0                                 # Flag to track comma printing

print_index_loop:
    beq  $t0, $s1, finish_print                 # If i == 10, finish

    sll  $t1, $t0, 2
    add  $t2, $s0, $t1
    lw   $t3, 0($t2)                            # x = array[i]

    bne  $t3, $s3, skip_print_index             # If x != max2, skip

    # Print comma separator for elements after the first
    beq  $t5, $zero, print_first_index
    la   $a0, comma
    li   $v0, 4
    syscall

print_first_index:
    move $a0, $t0                               # Print index i
    li   $v0, 1
    syscall
    li   $t5, 1                                 # Set flag = 1

skip_print_index:
    addi $t0, $t0, 1                            # i++
    j    print_index_loop

print_no_second:
    la   $a0, msg_no_second
    li   $v0, 4
    syscall

finish_print:
    la   $a0, newline
    li   $v0, 4
    syscall

    # Exit program
    li   $v0, 10
    syscall