#Dominick Ferro
#10/15/23 Midterm
#Assembly Language - MIPS Monster Game 

.data
gameArray: .space 16  # 4 slots for player and monster, 4 bytes each(2 for health, 2 for strength)
player_msg: .asciiz "Player Health: "
monster_msg: .asciiz "\nMonster Health: "
prompt: .asciiz "\nChoose action (1 for attack, 2 for heal): "
msg_dead: .asciiz "\nYou have been defeated!"
msg_win: .asciiz "\nYou defeated the monster!"
newline: .asciiz "\n"

.text
main:
    # Initialize player's strength and health
    li $v0, 41  # Random number syscall
    syscall
    addi $v0, $v0, 5  # Random strength between 5 and 12
    sw $v0, gameArray+4
    li $v0, 41
    syscall
    addi $v0, $v0, 25  # Random health between 25 and 50
    sw $v0, gameArray

    # Initialize monster's strength and health
    lw $t1, gameArray  # Load player's health
    lw $t2, gameArray+4  # Load player's strength
    li $v0, 41
    syscall
    mul $t3, $t1, $v0
    div $t3, $t3, 100  # 0-110% of player's health
    sw $t3, gameArray+8
    li $v0, 41
    syscall
    mul $t4, $t2, $v0
    div $t4, $t4, 100  # 0-110% of player's strength
    sw $t4, gameArray+12

# Main game loop
game_loop:
    # Display player and monster's stats
    jal display_stats

    # Player's turn
    jal player_turn

    # Check if monster is dead
    lw $t0, gameArray+8
    blez $t0, game_win

    # Monster's turn
    jal monster_turn

    # Check if player is dead
    lw $t0, gameArray
    blez $t0, game_over

    j game_loop

game_over:
    li $v0, 4
    la $a0, msg_dead
    syscall
    j exit

game_win:
    li $v0, 4
    la $a0, msg_win
    syscall

exit:
    li $v0, 10
    syscall

display_stats:
    # Display player's stats
    la $a0, player_msg
    li $v0, 4
    syscall
    lw $a0, gameArray
    li $v0, 1
    syscall

    # Add newline after player's health
    li $v0, 4
    la $a0, newline
    syscall

    # Display monster's stats
    la $a0, monster_msg
    li $v0, 4
    syscall
    lw $a0, gameArray+8
    li $v0, 1
    syscall

    jr $ra

player_turn:
    # Display prompt
    li $v0, 4
    la $a0, prompt
    syscall

    # Read choice
    li $v0, 5
    syscall
    beq $v0, 1, player_attack
    beq $v0, 2, player_heal
    jr $ra

player_attack:
    # Attack monster if health > 0
    lw $t1, gameArray+8
    blez $t1, skip_attack
    lw $t2, gameArray+4  # Load player's strength
    sub $t1, $t1, $t2  # Subtract player's strength from monster's health
    sw $t1, gameArray+8  # Update monster's health
    jr $ra

skip_attack:
    jr $ra

player_heal:
    # Add player's strength to health
    lw $t0, gameArray
    lw $t1, gameArray+4
    add $t0, $t0, $t1
    sw $t0, gameArray
    jr $ra

monster_turn:
    # Monster has 50% chance to attack
    li $v0, 41
    syscall
    blt $v0, 50, skip_monster_turn  # 50% chance

    lw $t2, gameArray+12  # Load monster's strength
    lw $t3, gameArray  # Load player's health
    sub $t3, $t3, $t2  # Subtract monster's strength from player's health
    sw $t3, gameArray  # Update player's health

skip_monster_turn:
    jr $ra
