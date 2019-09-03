require 'colorize'
require 'artii'
require_relative 'game_system.rb'

# the below code proves to myself that when i let one variable = an object, it will be that exact same object. and modifying one modifyes the other. like an array.

# objectmon_p0 = Objectmon.new("Gregachu", 'grass', [1, 4], 10)
# objectmon_p1 = Objectmon.new("Gregachu", 'grass', [1, 4], 10)
# objectmon_p2 = Objectmon.new("Gregachu", 'grass', [1, 4], 10)

# p objectmon_p0
# p objectmon_p1
# p objectmon_p2
# p ''

# test0 = objectmon_p0
# test1 = objectmon_p1
# test2 = objectmon_p2.dup

# p test0
# p test1
# p test2
# p ''

# p objectmon_p0
# p objectmon_p1
# p objectmon_p2
# p ''

# objectmon_p0.hp = 100
# objectmon_p2.hp = 500
# p test0
# p test2
# p ''

# p objectmon_p0
# p objectmon_p2
# p ''

######

# is there a way to store an object directly into a hash key?
om_gregachu = Objectmon.new("Gregachu", 'grass', [1, 4], 10)
om_jennizard = Objectmon.new("Jennizard", 'mountain', [9, 10], 2)
om_carlmander = Objectmon.new("Carlmander", 'volcano', [2, 5], 5)
om_lucymon = Objectmon.new("Lucymon", 'grass', [1, 1], 20)
om_stevosaur = Objectmon.new("Stevosaur", 'mountain', [1, 3], 5)
om_emileotto = Objectmon.new("Emileotto", 'volcano', [3, 4], 12)

objectmons = {
    om_gregachu: om_gregachu,
    om_jennizard: om_jennizard,
    om_carlmander: om_carlmander,
    om_lucymon: om_lucymon,
    om_stevosaur: om_stevosaur,
    om_emileotto: om_emileotto
}

player = Player.new("Lev", [objectmons[:om_carlmander].dup])

wild_objectmon = objectmons[:om_lucymon].dup


p player.objectmons[0]
p objectmons[:om_carlmander]
puts ''

p wild_objectmon
p objectmons[:om_lucymon]
p ''
