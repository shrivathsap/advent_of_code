import System.IO
import Text.Regex.TDFA
import Data.Map (Map)
import qualified Data.Map as Map
import Data.List
import Debug.Trace
import Data.Set (Set)
import qualified Data.Set as Set

update_lights on_lights command = 
    let
        bounds = (map (read::String->Int))(getAllTextMatches(command=~"[0-9]+")::[String])
        (x0,y0) = (bounds!!0, bounds!!1)
        (x1,y1) = (bounds!!2, bounds!!3)
        region_affected = Set.fromList [(x, y)|x<-[x0..x1], y<-[y0..y1]]
    in
        if isPrefixOf "turn on" command then Set.union on_lights region_affected
        else if isPrefixOf "turn off" command then Set.difference on_lights region_affected
        else Set.difference (Set.union on_lights region_affected) (Set.intersection on_lights region_affected)

update_brightness brightness command =
    let
        bounds = (map (read::String->Int))(getAllTextMatches(command=~"[0-9]+")::[String])
        (x0,y0) = (bounds!!0, bounds!!1)
        (x1,y1) = (bounds!!2, bounds!!3)
        region_affected = [(x, y)|x<-[x0..x1], y<-[y0..y1]]
        turn_on lights region = Map.insertWith (+) region 1 lights
        turn_off lights region = if region `Map.member` lights then Map.adjust (\x-> if x>1 then x-1 else 0) region lights else lights
        toggle lights region = Map.insertWith (+) region 2 lights
    in
        if isPrefixOf "turn on" command then (trace command) foldl' turn_on brightness region_affected
        else if isPrefixOf "turn off" command then (trace command) foldl' turn_off brightness region_affected
        else (trace command) foldl' toggle brightness region_affected

main = do
    handle <- openFile "day06.txt" ReadMode
    contents <- hGetContents handle
    let
        commands = lines contents
        init_config = Set.empty
        init_brightness = []
        final_config = foldl' update_lights Set.empty (commands)
        final_brightness = foldl' update_brightness Map.empty (commands)
    print(length final_config)
    print(sum (Map.elems final_brightness))