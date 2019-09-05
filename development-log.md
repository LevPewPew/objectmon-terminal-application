# Development Log

## Objectmon (Pokemon Style Game Terminal Application):

### <em>Day 1:</em>

---

So far I have created a 3x3 grid map system to represent the "world". The player can move around this grid and potentially be attacked by Wild Objectmon. The goal is to get from the top left corner of the map to the bottom right, reaching this map tile results in winning the game. The player loses if they lose all their Objectmon in their inventory.

I have created a combat system involving the Damage and Health Points attributes of Objectmon objects. They fight each other until one reaches 0 HP.

Today I plan to fix some bugs and potentially add an extra "move" to an Objectmon, at the moment there is simply "Attack".

At the moment the Wild Objectmon are hard coded into specific spots on the map, today I also want to have their location be random with each different play through.

### <em>Day 2:</em>

---

I didn't end up having time to give the Objectmon more abilities other than attack, nor did i get to implement the random spawning of Objectmons.

I did end up implementing a few other things though:
- high score table that i could read/write to. 
- ARGV options ("-r" to reset the high score, and "-d hard" to increase the difficulty by having less starting Objectmon in your inventory).
- easier use of the map by coupling tty-prompt gem with WASD keys as inputs to move around just by tapping (not having to use enter to submit input) the WASD keys.

I also added some error handling to deal with player name character limits, walking off the edge of the map, and for my ARGV.

And of course a ton of various bug fixes.

One note is that I made the mistake of not checking if there is already a gem for something, and i implemented my own error handling and parsing of the ARGV arguments when I could have just used a gem to save a lot of time. Lesson learned for next time.