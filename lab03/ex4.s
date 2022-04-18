.globl iterative
.globl recursive

.data
n: .word 8
m: .word 2

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, tester

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

tester:
	addi sp, sp, -4
    sw ra, 4(sp)
	jal ra, iterative
    
    addi sp, sp, -4
    sw ra, 4(sp)
    jal ra, recursive
    
    beq s0, s1, equal
    addi a0, x0, -1
    j finish_tester
    
    equal:
    addi a0, s0, 0
    
	finish_tester:
    lw ra, 8(sp)
    addi sp, sp, 8
    jalr ra

iterative:
    addi s0, x0, 0
    addi t3, x0, 0
    
    loop:
    beq t3, a0, finish_iterative
    addi s0, s0, 3
    addi t3, t3, 1
    j loop
    
    finish_iterative:
	jalr ra
    
recursive:
	addi sp, sp, -4
    sw ra, 4(sp)
    
	beq x0, a0, finish_recursive
	addi s1, s1, 3
    addi a0, a0, -1
	jal ra, recursive
    
    finish_recursive:
    lw ra, 4(sp)
    addi sp, sp, 4
	jalr ra

