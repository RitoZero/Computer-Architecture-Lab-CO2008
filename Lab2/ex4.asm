# Lab 2 - Exercise 4: Factorial Calculation using Recursion

.data
    prompt:     .asciiz "Enter an integer: "
    err_msg:    .asciiz "A factorial for your number can not be found."
    newline:    .asciiz "\n"

.text
.globl main

main:
    # ------------------------------------------------------------------
    # PHASE 1: Input & Validation
    # ------------------------------------------------------------------
    la   $a0, prompt                        # Print prompt
    li   $v0, 4
    syscall

    li   $v0, 5                             # Read integer n
    syscall
    move $s0, $v0                           # Save n to $s0

    # Check if n < 0 (negative check)
    bltz $s0, print_error                   # If n < 0, branch to error

    # ------------------------------------------------------------------
    # PHASE 2: Recursive Function Call
    # ------------------------------------------------------------------
    move $a0, $s0                           # Pass argument n to $a0
    jal  factorial                          # Call recursive function factorial(n)
    move $s1, $v0                           # Store result n! in $s1

    # Print factorial result
    move $a0, $s1
    li   $v0, 1
    syscall
    j    exit_program

print_error:
    la   $a0, err_msg
    li   $v0, 4
    syscall

exit_program:
    la   $a0, newline
    li   $v0, 4
    syscall

    # Exit program
    li   $v0, 10
    syscall

# ------------------------------------------------------------------
# RECURSIVE PROCEDURE: int factorial(int n)
# Input:  $a0 = n
# Output: $v0 = n!
# ------------------------------------------------------------------
factorial:
    # Stack Frame Allocation (8 bytes: $ra and $a0)
    addi $sp, $sp, -8
    sw   $ra, 4($sp)                        # Save Return Address
    sw   $a0, 0($sp)                        # Save current argument n

    # Base case check: if (n <= 1) return 1;
    li   $t0, 1
    ble  $a0, $t0, fact_base_case

    # Recursive step: return n * factorial(n - 1);
    addi $a0, $a0, -1                       # Parameter = n - 1
    jal  factorial                          # Recursive call: $v0 = factorial(n - 1)

    # Multiply result after recursive return
    lw   $a0, 0($sp)                        # Restore original n
    mult $a0, $v0                           # n * factorial(n - 1)
    mflo $v0                                # Load lower 32-bit result to $v0
    j    fact_return

fact_base_case:
    li   $v0, 1                             # Base case return value 1

fact_return:
    lw   $ra, 4($sp)                        # Restore return address
    addi $sp, $sp, 8                        # Deallocate stack frame
    jr   $ra                                # Return to caller