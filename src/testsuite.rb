require_relative 'game_system.rb'

def test_map_move_location
    map = Map.new
    
    begin
        map.set_location([0,0])
        if map.move_location('south') != [1, 0]
            raise("Map.move_location Test 1: FAIL\nMoving south from 0,0 did not result in 1,0 being the new location")
        end
        puts 'Map.move_location Test 1: PASS'
        puts ''
    rescue => error
        puts error
        puts ''
    end

    begin
        map.set_location([1,1])
        if map.move_location('east') != [1, 2]
            raise("Map.move_location Test 2: FAIL\nMoving east from 1,1 did not result in 1,2 being the new location")
        end
        puts 'Map.move_location Test 2: PASS'
        puts ''
    rescue => error
        puts error
        puts ''
    end

    begin
        map.set_location([1,2])
        if map.move_location('east') != [1, 2]
            raise("Map.move_location Test 3: FAIL\nMoving east from 1,2 did not result in 1,2 being the new location. Moving off the edge of the map should return in no movement being returned")
        end
        puts 'Map.move_location Test 3: PASS'
        puts ''
    rescue => error
        puts error
        puts ''
    end
end

def test_maptile_get_map_symbol
    map_tile_0_0 = MapTile.new([0, 0], 'mountain', false)
    map_tile_0_1 = MapTile.new([0, 1], 'grass', false)
    map_tile_0_2 = MapTile.new([2, 2], 'volcano', true)
    
    begin
        if map_tile_0_0.get_map_symbol != '  ^  '
            raise("MapTile.get_map_symbol Test 1: FAIL\nMountain terrain did not return ^")
        end
        puts 'MapTile.get_map_symbol Test 1: PASS'
        puts ''
    rescue => error
        puts error
        puts ''
    end
    
    begin
        if map_tile_0_1.get_map_symbol != '  "  '
            raise("MapTile.get_map_symbol Test 2: FAIL\nGrass terrain did not return \"")
        end
        puts 'MapTile.get_map_symbol Test 2: PASS'
        puts ''
    rescue => error
        puts error
        puts ''
    end
    
    begin
        if map_tile_0_2.get_map_symbol != ' /\~ '
            raise("MapTile.get_map_symbol Test 3: FAIL\nVolcano terrain did not return /\~")
        end
        puts 'MapTile.get_map_symbol Test 3: PASS'
        puts ''
    rescue => error
        puts error
        puts ''
    end
end

def test_player_get_score
    # 8 * 1.2 + 20 * 0.8 = 25.6 > 25
    om_gregachu = Objectmon.new('Gregachu', 'grass', (1..4), 10)
    om_carlmander = Objectmon.new('Carlmander', 'volcano', (2..5), 5)
    om_stevosaur = Objectmon.new('Stevosaur', 'mountain', (1..3), 5)
    objectmons = {
        om_gregachu: om_gregachu,
        om_carlmander: om_carlmander,
        om_stevosaur: om_stevosaur,
    }
    objectmons_starting = [objectmons[:om_gregachu].dup, objectmons[:om_carlmander].dup, objectmons[:om_stevosaur].dup]
    player = Player.new('TestPlayer', objectmons_starting)
    begin
        if player.get_score != 25
            raise("Player.get_score Test 1: FAIL\nThe given objectmons average damage and HP in the player inventory did not result in a scor eof 25")
        end
        puts 'Player.get_score Test 1: PASS'
        puts ''
    rescue => error
        puts error
        puts ''
    end
end

test_map_move_location
test_maptile_get_map_symbol
test_player_get_score
