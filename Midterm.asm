#Dominick Ferro
#10/15/23 Midterm
#Assembly Language - MIPS Monster Game 

.data
gameArray: .space 16  # Storage for player and monster stats, 4 slots, 4 bytes each
player_msg: .asciiz "Player Health: "
monster_msg: .asciiz "\nMonster Health: "
prompt: .asciiz "\nChoose action (1 for attack, 2 for heal): "
msg_dead: .asciiz "\nYou have been defeated!"
msg_win: .asciiz "\nYou defeated the monster!"
newline: .asciiz "\n"

.text
.globl main
main:
    # Initialize player and monster stats
    jal initialize_game

    # Main game loop
game_loop:
    # Display stats and handle player and monster turns
    jal display_stats
    jal player_turn
    lw $t0, gameArray+8
    blez $t0, game_win
    jal monster_turn
    lw $t0, gameArray
    blez $t0, game_over
    j game_loop

game_over:
    la $a0, msg_dead
    li $v0, 4
    syscall
    j exit

game_win:
    la $a0, msg_win
    li $v0, 4
    syscall

exit:
    li $v0, 10
    syscall

initialize_game:
    # Randomly initialize player's strength between 5 and 12
    li $a0, 5
    li $a1, 12
    li $v0, 42
    syscall
    sw $v0, gameArray+4

    # Randomly initialize player's health between 25 and 50
    li $a0, 25
    li $a1, 50
    li $v0, 42
    syscall
    sw $v0, gameArray

    # Randomly initialize monster's stats based on player's
    jal randomize_monster_stats
    jr $ra

randomize_monster_stats:
    lw $t1, gameArray  # Load player health
    lw $t2, gameArray+4  # Load player strength

    # Calculate 150% of player health
    li $t3, 3
    mul $t4, $t1, $t3
    div $t4, $t4, 2
    move $a1, $t4

    # Set range and get random monster health
    move $a0, $t1
    li $v0, 42
    syscall
    sw $v0, gameArray+8

    # Calculate 150% of player strength
    mul $t4, $t2, $t3
    div $t4, $t4, 2
    move $a1, $t4

    # Set range and get random monster strength
    move $a0, $t2
    li $v0, 42
    syscall
    sw $v0, gameArray+12
    jr $ra

display_stats:
    la $a0, player_msg
    li $v0, 4
    syscall
    lw $a0, gameArray
    li $v0, 1
    syscall
    la $a0, newline
    syscall
    la $a0, monster_msg
    li $v0, 4
    syscall
    lw $a0, gameArray+8
    li $v0, 1
    syscall
    jr $ra

player_turn:
    la $a0, prompt
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    li $v0, 1
    beq $t0, $v0, player_attack
    li $v0, 2
    beq $t0, $v0, player_heal
    jr $ra

player_attack:
    lw $t1, gameArray+8
    lw $t2, gameArray+4
    sub $t1, $t1, $t2
    sw $t1, gameArray+8
    jr $ra

player_heal:
    lw $t0, gameArray
    lw $t1, gameArray+4
    add $t0, $t0, $t1
    sw $t0, gameArray
    jr $ra

monster_turn:
    li $v0, 42  # Random number for decision
    li $a0, 0
    li $a1, 100
    syscall
    li $t1, 50
    bgt $v0, $t1, skip_monster_turn
    lw $t2, gameArray+12
    lw $t3, gameArray
    sub $t3, $t3, $t2
    sw $t3, gameArray

skip_monster_turn:
    jr $ra
