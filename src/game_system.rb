def run_game
    map_grid = initialize_map
    map_grid[0][0].player_is_here = true
    display_map(map_grid)
end

# map array grid is top to bottom left to right
# map_tile_x_y where x is the column and y is the row
# so map_tile_2_1 would represent the third column, second row
def initialize_map
    # hard coded instances for now, if time will make these more random
    map_tile_0_0 = MapTile.new('mountain', false)
    map_tile_1_0 = MapTile.new('grass', false)
    map_tile_2_0 = MapTile.new('mountain', false)
    map_tile_0_1 = MapTile.new('grass', false)
    map_tile_1_1 = MapTile.new('grass', false)
    map_tile_2_1 = MapTile.new('mountain', false)
    map_tile_0_2 = MapTile.new('mountain', false)
    map_tile_1_2 = MapTile.new('grass', false)
    map_tile_2_2 = MapTile.new('grass', false)
    map_grid = [
        [map_tile_0_0, map_tile_1_0, map_tile_2_0],
        [map_tile_0_1, map_tile_1_1, map_tile_2_1],
        [map_tile_0_2, map_tile_1_2, map_tile_2_2]
    ]
    return map_grid
end

def display_map(map_grid)
    puts "-------------------"
    map_grid.each do |row|
        puts "| #{row[0].player_is_here ? '<': ' '}#{row[0].get_map_symbol}#{row[0].player_is_here ? '>': ' '} | #{row[1].player_is_here ? '<': ' '}#{row[1].get_map_symbol}#{row[1].player_is_here ? '>': ' '} | #{row[2].player_is_here ? '<': ' '}#{row[2].get_map_symbol}#{row[2].player_is_here ? '>': ' '} |"
        # puts "| #{row[0].get_map_symbol}#{row[0].player_is_here ? '>' : ''} | #{row[1].get_map_symbol} | #{row[2].get_map_symbol} |"
        puts "-------------------"
    end
    
end

class MapTile
    attr_reader(:terrain)
    attr_accessor(:player_is_here)

    def initialize(terrain, wild_objectmon)
        @terrain = terrain
        @wild_objectmon = false
        @player_is_here = false
    end

    # generates a symbol to use on map grid display depending on terrain type of MapTile object
    def get_map_symbol
        case @terrain
        when 'mountain'
            return '^'
        when 'grass'
            return '"'
        else
            # if there is an error just default to grass
            return '"'
        end
    end
end