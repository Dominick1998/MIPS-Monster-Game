# MIPS Monster Game

## Overview
This project is a simple text-based game implemented in MIPS assembly language. The player and the monster have health and strength attributes. The player can choose to attack or heal each turn, while the monster has a chance to attack each round. The game continues until either the player or the monster is defeated.

## Features
- Randomized player and monster stats.
- Turn-based gameplay where the player can choose to attack or heal.
- Simple AI for the monster's turn.

## File Description
- `game.asm`: The main assembly file containing the game logic.

## How to Run
1. Ensure you have a MIPS simulator like MARS or SPIM installed.
2. Load the `game.asm` file into the simulator.
3. Assemble and run the program.
4. Follow the prompts in the console to play the game.

## Game Flow
1. The player's and the monster's stats are randomly initialized.
2. The player is prompted to choose an action:
   - Attack: Reduces the monster's health by the player's strength.
   - Heal: Increases the player's health by the player's strength.
3. The monster has a 50% chance to attack the player each round.
4. The game ends when either the player or the monster's health drops to zero.

## Code Structure
- **Data Segment**:
  - `gameArray`: Stores health and strength for both player and monster.
  - `player_msg`, `monster_msg`, `prompt`, `msg_dead`, `msg_win`, `newline`: String literals for game messages.

- **Text Segment**:
  - `main`: Initializes the game and starts the main game loop.
  - `game_loop`: Handles the main game loop logic.
  - `game_over`, `game_win`: Display end game messages and exit.
  - `display_stats`: Displays current health stats of player and monster.
  - `player_turn`: Handles the player's turn logic.
  - `player_attack`, `player_heal`: Perform the respective actions for the player.
  - `monster_turn`: Handles the monster's turn logic.

## License
This project is licensed under the MIT License.

## Author
**Dominick Ferro**

## Date
October 15, 2023

---
