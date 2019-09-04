# Day 1

So far I have created a 3x3 grid map system to represent the "world". The player can move around this grid and potentially be attacked by Wild Objectmon. The goal is to get from the top left corner of the map to the bottom right, reaching this map tile results in winning the game. The player loses if they lose all their Objectmon in their inventory.

I have created a combat system involving the Damage and Health Points attributes of Objectmon objects. They fight each other until one reaches 0 HP.

Today I plan to fix some bugs and potentially add an extra "move" to an Objectmon, at the moment there is simply "Attack".

At the moment the Wild Objectmon are hard coded into specific spots on the map, today I also want to have their location be random with each different play through.