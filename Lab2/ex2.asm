# Lab 2 - Exercise 2: Recursive GCD and LCM

.data
    prompt_a:   .asciiz "a="
    prompt_b:   .asciiz "b="
    err_msg:    .asciiz "Inputs must be positive integers (>0)! Please re-enter.\n"
    msg_gcd:    .asciiz "GCD="
    msg_lcm:    .asciiz ", LCM="
    newline:    .asciiz "\n"

.text
.globl main

main:
    # ------------------------------------------------------------------
    # PHASE 1: Input Validation Loop (a > 0, b > 0)
    # ------------------------------------------------------------------
get_input_a:
    la   $a0, prompt_a                      # Print prompt "a="
    li   $v0, 4
    syscall

    li   $v0, 5                             # Read integer a
    syscall
    move $s0, $v0                           # Save a to $s0

    blez $s0, input_error                   # If a <= 0, prompt error

get_input_b:
    la   $a0, prompt_b                      # Print prompt "b="
    li   $v0, 4
    syscall

    li   $v0, 5                             # Read integer b
    syscall
    move $s1, $v0                           # Save b to $s1

    blez $s1, input_error                   # If b <= 0, prompt error
    j    start_calculation

input_error:
    la   $a0, err_msg
    li   $v0, 4
    syscall
    j    get_input_a                        # Restart input process

# ------------------------------------------------------------------
# PHASE 2: Execution & Calls
# ------------------------------------------------------------------
start_calculation:
    # Call recursive function gcd(a, b)
    move $a0, $s0                           # Argument 1: a
    move $a1, $s1                           # Argument 2: b
    jal  gcd
    move $s2, $v0                           # $s2 = GCD(a, b)

    # Calculate LCM = (a / GCD) * b to prevent early 32-bit overflow
    div  $s0, $s2                           # a / GCD
    mflo $t0                                # $t0 = a / GCD
    mult $t0, $s1                           # (a / GCD) * b
    mflo $s3                                # $s3 = LCM

# ------------------------------------------------------------------
# PHASE 3: Print Formatting ("GCD=X, LCM=Y")
# ------------------------------------------------------------------
    la   $a0, msg_gcd
    li   $v0, 4
    syscall

    move $a0, $s2                           # Print GCD
    li   $v0, 1
    syscall

    la   $a0, msg_lcm
    li   $v0, 4
    syscall

    move $a0, $s3                           # Print LCM
    li   $v0, 1
    syscall

    # Exit program
    li   $v0, 10
    syscall

# ------------------------------------------------------------------
# RECURSIVE PROCEDURE: int gcd(int a, int b)
# Input:  $a0 = a, $a1 = b
# Output: $v0 = GCD(a, b)
# ------------------------------------------------------------------
gcd:
    # Epilogue/Prologue: Allocate stack frame (12 bytes)
    addi $sp, $sp, -12
    sw   $ra, 8($sp)                        # Save Return Address
    sw   $a0, 4($sp)                        # Save parameter a
    sw   $a1, 0($sp)                        # Save parameter b

    # Base case check: if (b == 0) return a;
    beq  $a1, $zero, gcd_base_case

    # Recursive step: return gcd(b, a % b);
    div  $a0, $a1                           # a / b
    mfhi $t0                                # $t0 = a % b

    move $a0, $a1                           # Parameter 1 = b
    move $a1, $t0                           # Parameter 2 = a % b
    jal  gcd                                # Recursive call

    j    gcd_return

gcd_base_case:
    move $v0, $a0                           # Return a as GCD result

gcd_return:
    # Restore registers from stack frame
    lw   $a1, 0($sp)
    lw   $a0, 4($sp)
    lw   $ra, 8($sp)
    addi $sp, $sp, 12                       # Deallocate stack space
    jr   $ra                                # Return to caller