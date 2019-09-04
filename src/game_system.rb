require 'colorize'
require 'artii'
require 'terminal-table'
require 'tty-prompt'

SCORE_FACTOR_HP = 0.8
SCORE_FACTOR_DMG = 1.2

def run_game
    system('clear')
    puts ''
    # print title of game in ascii art to be fancy
    artii = Artii::Base.new :font => 'nancyj-fancy'
    puts artii.asciify('Objectmon!').colorize(:magenta)
    puts ''

    # FIXME hard coded, fix if time
    # Give some beginning guide and instuctions (FIXME: potentially elaborate on this further to make user experience better/easier/more-intuitive)
    puts 'Make your way to the South-East tile to win!'
    puts ''

    om_gregachu = Objectmon.new("Gregachu", 'grass', (1..4), 10)
    om_jennizard = Objectmon.new("Jennizard", 'mountain', (9..10), 2)
    om_carlmander = Objectmon.new("Carlmander", 'volcano', (2..5), 5)
    om_lucymon = Objectmon.new("Lucymon", 'grass', (1..1), 30)
    om_stevosaur = Objectmon.new("Stevosaur", 'mountain', (1..3), 5)
    om_emileotto = Objectmon.new("Emileotto", 'volcano', (3..4), 12)

    objectmons = {
        om_gregachu: om_gregachu,
        om_jennizard: om_jennizard,
        om_carlmander: om_carlmander,
        om_lucymon: om_lucymon,
        om_stevosaur: om_stevosaur,
        om_emileotto: om_emileotto
    }

    # run the menu loop to be navigated through. menu is being used as a way to control character actions and choose what info to display to user
    Menu.menu_system(objectmons)
end

class Menu
    def self.menu_system(objectmons)
        loop do
            # initialize map (sets location of wild objectmon as well as the winning tile) and set player location. these are done inside the menu system so that each time a new game is played without exiting the app it will reset the map.
            map = Map.new
            # set the starting position
            map.set_location([0,0])
            choice = main_menu
            case choice
            when 'play'
                objectmons_starting = [objectmons[:om_gregachu].dup, objectmons[:om_jennizard].dup, objectmons[:om_carlmander].dup]
                loop do
                    begin
                        puts '***********************************************************'
                        puts '                    Enter a Player Name                    '.colorize(:color => :black, :background => :white)
                        puts '***********************************************************'
                        print '> '
                        choice = gets.strip
                        if !choice.length.between?(3, 10)
                            system('clear')
                            raise('Player Name must be 3 to 10 characters!'.colorize(:color => :black, :background => :light_yellow))
                        end
                        break
                    rescue => error
                        puts error
                        puts ''
                    end
                end
                system('clear')
                player = Player.new(choice, objectmons_starting)
                play_menu(map, player, objectmons)
            when 'scores'
                table_rows = []
                File.open('test_high_scores.csv', 'r').each_with_index do |line, i|
                    if i == 0
                        table_rows << line.strip.split(',')
                        table_rows << :separator
                    else line.length > 0
                        table_rows << line.strip.split(',')
                    end
                end
                table = Terminal::Table.new :rows => table_rows
                table.align_column(0, :center)
                table.align_column(2, :right)
                puts table
                puts ''
            when 'quit'
                exit
            end
        end
    end

    def self.main_menu
        loop do
            puts '***********************************************************'
            puts '     Welcome to Objectmon, what would you like to do?      '.colorize(:color => :black, :background => :white)
            puts '-----------------------------------------------------------'
            puts '1. Play'.colorize(:cyan)
            puts '2. High Scores'.colorize(:cyan)
            puts '3. Quit'.colorize(:cyan)
            puts '***********************************************************'
            print '> '
            choice = gets.strip.to_i
            puts ''
            system('clear')
            case choice
            when 1
                return 'play'
            when 2
                return 'scores'
            when 3
                return 'quit'
            end
        end
    end

    # FIXME maybe move these display maps around and the system clears
    def self.play_menu(map, player, objectmons)
        prompt = TTY::Prompt.new
        map.display_map
        loop do
            # choose and then move in a direction on the map, game is won if player reaches the winning tile
            choice = menu_ask_direction
            current_location = map.move_location(choice)
            if map.map_grid[map.winning_tile[0]][map.winning_tile[1]].player_is_here
                puts '                                          '.colorize(:color => :black, :background => :green)
                puts '  Congratulations! You made it! You won!  '.colorize(:color => :black, :background => :green)
                puts '                                          '.colorize(:color => :black, :background => :green)
                puts ''
                HighScores.add_score(player)
                prompt.keypress("Press any key to continue, returning to main menu automatically in :countdown ...", timeout: 10)
                system('clear')
                break
            end

            # check if a wild objectmon appears (is instantiated), and begin fight if so
            if map.map_grid[current_location[0]][current_location[1]].wild_objectmon
                map.display_map
                # wild_objectmon = Objectmon.new("Stephamon", 'mountain', (15..20), 500) # TESTING objectmon, don't ship with this
                wild_objectmon = objectmons[:om_stevosaur].dup # UNCOMMENT on shipping
                result = fight(player, player.objectmons, wild_objectmon)
                # the fight method will break and return 'load-menu' if it broke due to losing the game. in turn we will break from here as well to return to the main menu
                if result == 'load-menu'
                    break
                end
            else
                result = 'no-fight'
            end

            # if the fight results in a loss, return the player to the tile in the direction they came from
            if result
                map.map_grid[current_location[0]][current_location[1]].wild_objectmon = false
            elsif !result
                case choice
                when 'north'
                    reset = 'south'
                when 'south'
                    reset = 'north'
                when 'east'
                    reset = 'west'
                when 'west'
                    reset = 'east'
                end
                map.move_location(reset)
            else
                # do nothing
            end
            # show map with every non-combat action so player doesn't have to scroll up for last map position
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
        system('clear')
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

    # returns true if win, returns false if loss
    def self.fight(player, objectmons, objectmon1)
        prompt = TTY::Prompt.new
        round = 1
        objectmon0 = nil
        loop do
            if round == 1
                puts "A wild #{objectmon1.name} appears!"
                puts ''
                puts '***********************************************************'
                puts '                   Select an Objectmon!                    '.colorize(:color => :black, :background => :white)
                puts '-----------------------------------------------------------'
                player.objectmons.each_with_index do |objectmon, i|
                    puts "#{i + 1}. #{objectmon.name}".colorize(:cyan)
                end
                puts '***********************************************************'
                print '> '
                choice_objectmon = gets.strip.to_i
                puts ''
                system('clear')
                objectmon0 = player.objectmons[choice_objectmon - 1].dup
            end
            puts "#{objectmon0.name}".colorize(:green) + " HP: #{objectmon0.hp}"
            puts "#{objectmon1.name}".colorize(:red) + " HP: #{objectmon1.hp}"
            puts '***********************************************************'
            puts "                         Round #{round}!                          ".colorize(:color => :black, :background => :white)
            puts '-----------------------------------------------------------'
            puts '1. Attack'.colorize(:cyan)
            puts '***********************************************************'
            print '> '
            choice_action = gets.strip.to_i
            puts ''
            system('clear')
            case choice_action
            when 1
                dmg_by_objectmon0 = rand(objectmon0.dmg)
                dmg_by_objectmon1 = rand(objectmon1.dmg)
                puts "#{objectmon0.name}".colorize(:green) + " did #{dmg_by_objectmon0} to " + "#{objectmon1.name}".colorize(:red)
                objectmon1.hp -= dmg_by_objectmon0
                # enemy objectmon defeated
                if objectmon1.hp <= 0
                    puts ''
                    puts "#{objectmon0.name}".colorize(:green) + " HP: #{objectmon0.hp}"
                    puts "#{objectmon1.name}".colorize(:red) + " HP: #{objectmon1.hp}"
                    puts ''
                    puts "You have defeated " + "#{objectmon1.name}".colorize(:red) + "!"
                    puts ''
                    return true
                    # player objectmon defeated
                else
                    puts "#{objectmon1.name}".colorize(:red) + " did #{dmg_by_objectmon1} to " + "#{objectmon0.name}".colorize(:green)
                    puts ''
                    objectmon0.hp -= dmg_by_objectmon1
                    if objectmon0.hp <= 0
                        system('clear')
                        puts "#{objectmon1.name}".colorize(:red) + " has defeated " + "#{objectmon0.name}".colorize(:green) + "!"
                        puts ''
                        player.objectmons.delete_at(choice_objectmon - 1)
                        if player.objectmons.length <= 0
                            puts '                                                                               '.colorize(:color => :white, :background => :red)
                            puts '  You have lost your last Objectmon... you lose. Try again you filthy casual.  '.colorize(:color => :white, :background => :red)
                            puts '                                                                               '.colorize(:color => :white, :background => :red)
                            puts ''
                            # this syntax means upon break return the string 'lost', in the loop that this loop is nested in, we will check if this is what the method returned, and use it to break the outer loop if so, returning us to the main menu
                            HighScores.add_score(player)
                            prompt.keypress("Press any key to continue, returning to main menu automatically in :countdown ...", timeout: 10)
                            system('clear')
                            break 'load-menu'
                        end
                        return false
                    end
                end
            else
                p 'Invalid choice selected, please try again'
                puts ''
            end
            round += 1
        end
    end

    # this is here because menu_system is a class method and i have compartmentalised some of it's tasks into other methods that it will access. these other methods have to be class methods so that menu_system has access to them. however i don't want to allow other classes or scripts to be able to access these so i have put them into this private_class_method statement
    private_class_method(:main_menu, :play_menu, :menu_ask_direction, :fight)
end

class Player
    attr_reader(:name)
    attr_accessor(:objectmons)

    def initialize(name, objectmons)
        @name = name
        @objectmons = objectmons
    end

    # this method returns a score to use for high score table upon a win
    # the total HP and total average damage output remaining across all objectmons is used to calculate the score
    def get_score
        total_hp = objectmons
            .map { |objectmon| objectmon.hp }
            .sum
        total_avg_dmg = objectmons
            .map { |objectmon| objectmon.dmg.sum / objectmon.dmg.size.to_f }
            .sum
        score = total_hp * SCORE_FACTOR_HP + total_avg_dmg * SCORE_FACTOR_DMG
        # round down
        return score.to_i
    end
end

class Objectmon
    attr_reader(:name, :type, :dmg)
    attr_accessor(:hp)

    def initialize(name, type, dmg, hp)
        @name = name
        @type = type
        @dmg = dmg
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
                    begin
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
                            raise("You cannot move further #{direction.capitalize} lest you fall off the edge of the earth!".colorize(:color => :black, :background => :light_yellow))
                        end
                    rescue => error
                        puts error
                        puts ''
                    end
                end
            end
        end
        @map_grid[y_coord][x_coord].player_is_here = true
        return [y_coord, x_coord]
    end

    def set_location(location)
        @map_grid.each do |row|
            row.each do |tile|
                tile.player_is_here = false
            end
        end
        @map_grid[location[0]][location[1]].player_is_here = true
        return [location[0], location[1]]
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

class HighScores
    def self.add_score(player)
        new_lines = []
        headers = nil
        File.open('test_high_scores.csv', 'r').each_with_index do |line, i|
            if i == 0
                headers = line.split(',')
            elsif line.length > 0
                new_lines << line.split(',')
            end
        end
        new_lines << ["X", "#{player.name}", "#{player.get_score}\n"]
        # sort scores from highest to lowest, then remap the array of table lines to itself but with the "Place" column reorganised to reflect the added entry. there is no map with index so need to use an each with index first
        new_lines = new_lines
            .sort { |a, b| b[2] <=> a[2] }
            .map.with_index { |line, i| ["#{i + 1}"] + line[(1..2)] }
        new_lines.unshift(headers)
        new_lines = new_lines.map do |line|
            line.join(',')
        end

        File.open('test_high_scores.csv', 'w') do |file|
            file.write(new_lines.join)
        end
        
        # FIXME in the future i would return the rank somehow
        return player.get_score
    end
end
