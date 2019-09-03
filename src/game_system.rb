require 'colorize'
require 'artii'

def run_game
    puts ''
    # print title of game in ascii art to be fancy
    artii = Artii::Base.new :font => 'slant'
    puts artii.asciify('Objectmon!')
    puts ''

    # FIXME hard coded, fix if time
    # Give some beginning guide and instuctions (FIXME: potentially elaborate on this further to make user experience better/easier/more-intuitive)
    puts 'Make your way to the South-East tile to win!'
    puts ''
    # initialize map, player location and display map to user
    map = Map.new
    map.map_grid[0][0].player_is_here = true
    map.display_map

    # initialize player and their objectmons
    objectmon_p0 = Objectmon.new("Gregachu", 'grass', [1, 4], 10)
    # LEFTOFF
    # objectmon_p1 = Objectmon.new("Gregachu", 'grass', [1, 4], 10)
    # objectmon_p2 = Objectmon.new("Gregachu", 'grass', [1, 4], 10)
    
    # FIXME ask for playername
    player = Player.new("Lev", [objectmon_p0])

    # run the menu loop to be navigated through. menu is being used as a way to control character actions and choose what info to display to user
    Menu.menu_system(map, player)
end

class Menu
    def self.menu_system(map, player)
        loop do
            # choose and then move in a direction on the map, game is won if player reaches the winning tile
            choice = menu_ask_direction
            current_location = map.move_location(choice)
            map.display_map
            if map.map_grid[map.winning_tile[0]][map.winning_tile[1]].player_is_here
                puts '                                          '.colorize(:color => :black, :background => :green)
                puts '  Congratulations! You made it! You won!  '.colorize(:color => :black, :background => :green)
                puts '                                          '.colorize(:color => :black, :background => :green)
                puts ''
                exit
            end

            # check if a wild objectmon appears (is instantiated), and begin fight if so
            if map.map_grid[current_location[0]][current_location[1]].wild_objectmon
                # wild_objectmon = Objectmon.new("Stephamon", 'mountain', [15, 20], 5) # TESTING objectmon, don't ship with this
                wild_objectmon = Objectmon.new("Stephamon", 'mountain', [1, 2], 5) # UNCOMMENT on shipping
                fight(player, player.objectmons[0], wild_objectmon)
            end

            map.display_map
        end

        return
    end

    def self.menu_ask_direction
        puts '***********************************************************'
        puts '         What direction would you like to move in?         '.colorize(:color => :black, :background => :white)
        puts '-----------------------------------------------------------'
        puts '1. North'.colorize(:cyan)
        puts '2. South'.colorize(:cyan)
        puts '3. East'.colorize(:cyan)
        puts '4. West'.colorize(:cyan)
        puts '***********************************************************'
        print '> '
        choice = gets.strip.to_i
        puts ''
        case choice
        when 1
            return 'north'
        when 2
            return 'south'
        when 3
            return 'east'
        when 4
            return 'west'
        else
            p 'invalid choice'
        end
    end

    def self.fight(player, objectmon0, objectmon1)
        round = 1
        loop do
            puts "#{objectmon0.name} HP: #{objectmon0.hp}"
            puts "#{objectmon1.name} HP: #{objectmon1.hp}"
            puts '***********************************************************'
            puts "Round #{round}!:"
            puts '-----------------------------------------------------------'
            puts '1. Attack'.colorize(:cyan)
            puts '***********************************************************'
            print '> '
            choice = gets.strip.to_i
            puts ''
            case choice
            when 1
                dmg_by_objectmon0 = rand(objectmon0.dmg)
                dmg_by_objectmon1 = rand(objectmon1.dmg)
                objectmon1.hp -= dmg_by_objectmon0
                if objectmon1.hp <= 0
                    puts "You have defeated #{objectmon1.name}!"
                    puts ''
                    break
                else
                    objectmon0.hp -= dmg_by_objectmon1
                    if objectmon0.hp <= 0
                        # FIXME replace with variable index somehow, when selecting with tty-prompt store selection in variable and use tha tas index
                        puts "#{objectmon1.name} has defeated #{objectmon0.name}!"
                        puts ''
                        player.objectmons.delete_at(0)
                        if player.objectmons.length <= 0
                            puts '                                                                               '.colorize(:color => :white, :background => :red)
                            puts '  You have lost your last Objectmon... you lose. Try again you filthy casual.  '.colorize(:color => :white, :background => :red)
                            puts '                                                                               '.colorize(:color => :white, :background => :red)
                            puts ''
                            exit
                        end
                    end
                end
                puts "#{objectmon0.name} did #{dmg_by_objectmon0} to #{objectmon1.name}"
                puts "#{objectmon1.name} did #{dmg_by_objectmon1} to #{objectmon0.name}"
                puts ''
            else
                p 'invalid choice'
            end
            round += 1
        end
    end

    private_class_method(:menu_ask_direction, :fight)
end

class Player
    attr_reader(:name, :objectmons)

    def initialize(name, objectmons)
        @name = name
        @objectmons = objectmons
    end
end

class Objectmon
    attr_reader(:name, :type, :dmg)
    attr_accessor(:hp)

    def initialize(name, type, dmg, hp)
        @name = name
        @type = type
        @dmg = (dmg[0]..dmg[1])
        @hp = hp
    end
end

# map array grid is top to bottom left to right
# map_tile_y_x where and y is the row and x is the column
# so map_tile_2_1 would represent the second row, third column.
# i have went against convention of x,y and did y,x instead so that we
# can look at the 2D array and line up the indexes with it
class Map
    attr_reader(:map_grid, :winning_tile)

    def initialize
        # FIXME hard coded instances for now, if have time will make these more random and use a loop
        # FIXME use hashes to generate instances for code clarity and maintainability
        @map_tile_0_0 = MapTile.new([0, 0], 'mountain', false)
        @map_tile_0_1 = MapTile.new([0, 1], 'grass', false)
        @map_tile_0_2 = MapTile.new([0, 2], 'mountain', false)
        @map_tile_1_0 = MapTile.new([1, 0], 'grass', false)
        @map_tile_1_1 = MapTile.new([1, 1], 'grass', false)
        @map_tile_1_2 = MapTile.new([1, 2], 'volcano', false)
        @map_tile_2_0 = MapTile.new([2, 0], 'mountain', true)
        @map_tile_2_1 = MapTile.new([2, 1], 'mountain', false)
        @map_tile_2_2 = MapTile.new([2, 2], 'grass', false)
        @map_grid = [
            [@map_tile_0_0, @map_tile_0_1, @map_tile_0_2],
            [@map_tile_1_0, @map_tile_1_1, @map_tile_1_2],
            [@map_tile_2_0, @map_tile_2_1, @map_tile_2_2]
        ]
        # FIXME hard coded for now
        @winning_tile = [2, 2]
    end
    
    def display_map
        puts "World Map:"
        puts '-------------------------'
        # for each row, get the map symbol associated with the terrain of the MapTile object. surround by < > symbols to indicate current location of player (current location is stored in a flag in the map tile)
        @map_grid.each do |row|
            puts "|#{row[0].player_is_here ? "       ".colorize(:color => :black, :background => :white) : "       "}|#{row[1].player_is_here ? "       ".colorize(:color => :black, :background => :white) : "       "}|#{row[2].player_is_here ? "       ".colorize(:color => :black, :background => :white) : "       "}|"
            
            puts "|#{row[0].player_is_here ? " #{row[0].get_map_symbol} ".colorize(:color => :black, :background => :white) : " #{row[0].get_map_symbol} "}|#{row[1].player_is_here ? " #{row[1].get_map_symbol} ".colorize(:color => :black, :background => :white) : " #{row[1].get_map_symbol} "}|#{row[2].player_is_here ? " #{row[2].get_map_symbol} ".colorize(:color => :black, :background => :white) : " #{row[2].get_map_symbol} "}|"
            
            puts "|#{row[0].player_is_here ? "       ".colorize(:color => :black, :background => :white) : "       "}|#{row[1].player_is_here ? "       ".colorize(:color => :black, :background => :white) : "       "}|#{row[2].player_is_here ? "       ".colorize(:color => :black, :background => :white) : "       "}|"
            puts '-------------------------'
        end
        puts ''
    end
    
    def move_location(direction)
        x_coord = nil
        y_coord = nil
        @map_grid.each_with_index do |row, i|
            row.each do |tile|
                if tile.player_is_here
                    y_coord = tile.coords[0]
                    x_coord = tile.coords[1]
                    tile.player_is_here = false
                    # the second part of the && boolean condition ensures that if the player is on the edge,
                    # that the position doesn't wrap around or create any other undesired
                    # behaviour but simply tells the user they cannot move in that direction
                    if (direction == 'north') && (y_coord != 0)
                        y_coord += -1
                        x_coord += 0
                    elsif (direction == 'south') && (y_coord != @map_grid.length - 1)
                        y_coord += 1
                        x_coord += 0
                    elsif (direction == 'east') && (x_coord != row.length - 1)
                        y_coord += 0
                        x_coord += 1
                    elsif (direction == 'west') && (x_coord != 0)
                        y_coord += 0
                        x_coord += -1
                    else
                        p "You cannot move further #{direction} lest you fall off the edge of the earth!"
                        puts ''
                    end
                end
            end
        end
        @map_grid[y_coord][x_coord].player_is_here = true
        return [y_coord, x_coord]
    end
end

class MapTile
    attr_reader(:terrain, :coords)
    attr_accessor(:player_is_here, :wild_objectmon)

    def initialize(coords, terrain, wild_objectmon)
        @coords = coords
        @terrain = terrain
        @wild_objectmon = wild_objectmon
        @player_is_here = false
    end

    # generates a symbol to use on map grid display depending on terrain type of MapTile object
    def get_map_symbol
        case @terrain
        when 'mountain'
            return '  ^  '
        when 'grass'
            return '  "  '
        when 'volcano'
            return ' /\~ '
        else
            # if there is an error just default to grass
            return '  "  '
        end
    end
end
