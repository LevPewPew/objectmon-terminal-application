# objectmon-terminal-application

Welcome to Objectmon, a very, very basic Pokemon style game running as a text/ascii based terminal application.

# Help File

## System Requirements

- Ruby 2.5.1
- A Bash terminal

## Installation and Run Instructions

1. Unzip the file submitted in canvas and navigate via terminal to the objectmon-terminal-application/src/ directory. Or clone the Repo, git@github<i></i>.com:LevPewPew/objectmon-terminal-application.git
2. Run the build<i></i>.sh file (located in objectmon-terminal-application/src/) using bash to build the game. This build file will install dependencies required.
3. Run the objectmon.rb file using ruby to launch the game. For best results please run the game in a full screen terminal.
4. Optional arguments can be given when launching the game
    - Change difficulty from Normal to Hard with `-d hard`. This gives you just 1 starting Objectmon instead of 3.
    - Reset the High Score table with `-r`

## Gameplay instructions

You, the Player, must make it from the North-West map tile to the South-East map tile without losing all you Objectmon to battle.

As you travel the map you may run into Wild Objectmon and begin battle. Choose one of your Objectmon and fight. Once a Wild Objectmon has been defeated that map tile will be safe from there onwards.

### *The Map*

* Ascii art icons on the map represent terrain type
  - Grass terrain represented by "
  - Mountain terrain represented by ^
  - Volcano terrain represented by /\~

* Different terrain types have different kinds of Wild Objectmon spawning there, a random Objectmon of the same type as the terrain.

* Use WASD to navigate the map, the white square represents the location of the Player.

### *Battle*

* When a Wild Objectmon appears, battle begins. Select one of your remaining Objectmon to continue.

* Select a move (currently only the move "Attack" is supported).

* When a Player or Wild Objectmon Health Points (HP) reaches 0, the battle is over and that Objectmon is no longer in the game.

### *Objectmon Stats*

| Name          | Type          | Damage  | HP  |
|:-------------:|:-------------:|:-------:|:---:|
| Gregachu      | Grass         | 1 - 4   | 10  |
| Jennizard     | Mountain      | 9 - 10  | 2   |
| Carlmander    | Volcano       | 20 - 50 | 30  |
| Lucymon       | Grass         | 1       | 30  |
| Stevosaur     | Mountain      | 1 - 3   | 5   |
| Emileotto     | Volcano       | 3 - 4   | 120 |

# Software Development Plan

## Statement of Purpose and Scope

The Objectmon application is intended to be a terminal based video game. It will allow a player to move around a world map and fight Wild Objectmon monsters with their own inventory of Objectmon monsters.

This application solves a few problems:
- Wanting to play a game with little money. Being a terminal based application it requires very little computer resources and so practically anyone can play, you don't need to invest lots of money into expensive hardware. The game is also free to play.
- A lack of fun. If someone wants to have fun they can run this application and play a game.

The target audience of this application is anyone that has ever dreamt of adventuring around a virtual world forcing wild animals to fight each other.

A member of the target audience would use this application by installing and running the game and then playing it until they either win or lose. They can also record high scores and compete against friends to get the highest score.

## Features

### *World Map to Navigate*

The game will draw a map in the terminal using ascii characters to represent a 3x3 grid of map tiles. Each map tile is an instance of a MapTile object and has attributes such as if a Wild Objectmon will appear or what type of terrain is on that tile. The entire map itself is managed by a Map class.

Each MapTile object that has a flag to spawn Wild Objectmon will then randomly pick from a pool of Objectmon, case statements are used to decide which pool to use, based on matching the terrain type with the Objectmon types.

Error handling has been included to account for the Player attempting to move off the edge of the map, it will stop that person from moving from that Map Tile and print a warning message explaining why they have not moved.

### *Combat System*

When the Player moves to a map tile with a Wild Objectmon, a fight begins. The Player then chooses a Objectmon it has, stored in an Array that is an attribute of the Player class. Each Objectmon in this array is also it's own instance of the Objectmon class. This is done so that the state of the remaining Health Points of the Objectmon are preserved between battles.

After choosing an Objectmon the Player then chooses a combat action. Damage is calculated using the damage attributes of each of the two Objectmon instances.

Once an Objectmon HP reaches 0, combat is over.

Error handling has been included by printing to the player that they have chosen an invalid choice, if they Player picks an option not listed by the game.

### *High Score Table*

When the Player wins the game a score is given based on how much total HP they have left amongst all their Objectmon, as well as the total average damage amongst all their Objectmon.

A CSV file is used to read/write and store high score information. This allows the high scores to persist between runs of the application. The high score table is formatted and displayed neatly using the `terminal-table` gem.

A user can provide the argument `-r` when launching the application to reset the high score table.

Error handling has been included for ARGV, if an unsupported argument is given, the user will be informed and the application will fail to load.

## User Interaction and Experience

The user can find out how to run the application and play the game that it loads by reading the Help File at the top of this document, specifically the **Installation and Run Instructions** and **Gameplay instructions** headings.

Errors will be handled by begin/rescue and raise statements. An error, warning or guidance message will be printed to the terminal.

## Control Flow Diagram

Follow this [link](https://drive.google.com/open?id=1Dd0JuiIgbRKqyprzvLRBoq88v09D9O2X) to view the Control Flow Diagram. Or just open the PDF file in the project_management folder included in the submission ZIP file.

## Implementation Plan

I used a Trello board for my implementation plan. I used it to create task and feature checklists, with due dates to have time management. It can be viewed [here](https://trello.com/b/nwIEDiKE)

## Testing

Manual tests and their results can be viewed [here](https://docs.google.com/spreadsheets/d/1LaO99VlT9dDgA9ELo-uW1h0Ls_aixWZwOVlXnfrfh38/edit?usp=sharing)

To conduct automated test, please use Ruby to run testsuite.rb, which is located in objectmon-terminal-application/src/

## Developer Operations

Source control and commit history can be viewed in the [project github repo](https://github.com/LevPewPew/objectmon-terminal-application)

Evidence of project management can be viewed in this [Trello board](https://trello.com/b/nwIEDiKE). Screenshots of progress in project management can be accessed in the objectmon-terminal-application/project_management/project_management_tool_screenshots/ folder

Developer tools have been used by writing automated testing scripts and a package dependancy installer, as mentioned above in this document under the **Testing** and **Installation and Run Instructions** headings respectively.
