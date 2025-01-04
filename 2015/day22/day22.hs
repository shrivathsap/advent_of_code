import Data.Map (Map)
import qualified Data.Map as Map
import Data.List ( sortBy )

data Spell = Spell {cost::Int,
                    damage::Int,
                    heal::Int,
                    armour::Int,
                    mana::Int,
                    turns::Int} deriving (Ord, Eq, Show)

magic_missile = Spell 53 4 0 0 0 0
drain = Spell 73 2 2 0 0 0
shield = Spell 113 0 0 7 0 6
poison = Spell 173 3 0 0 0 6
recharge = Spell 229 0 0 0 101 5
spells = [magic_missile, drain, shield, poison, recharge]

name :: Spell -> String
name spell
    |spell==magic_missile = "Magic missile"
    |spell==drain = "Drain"
    |spell==shield = "Shield"
    |spell==poison = "Poison"
    |spell==recharge = "Recharge"

update_state :: ((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String]) -> Spell -> ((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])
update_state (hero, boss, damage_stack, mana_used, spells_used) spell =
    let
        (hero_hp, hero_mana, hero_armour) = hero
        (boss_hp, boss_attack) = boss
        new_mana_used = mana_used + (cost spell)

        --player's turn, stack effects
        hero_hp1 = hero_hp + sum [heal x | x<-Map.keys damage_stack]
        hero_mana1 = hero_mana + sum [mana x | x<-Map.keys damage_stack]
        hero_armour1 = if (shield `elem` (Map.keys damage_stack)) then (armour shield) else 0
        boss_hp1 = boss_hp - sum [damage x | x<-Map.keys damage_stack]
        stack1 =  Map.filter (>0) $ foldr (\x d -> Map.insertWith (+) x (-1) d) damage_stack (Map.keys damage_stack)

        --player's turn
        hero_hp2 = hero_hp1 + (heal spell)
        hero_mana2 = hero_mana1 - (cost spell)
        hero_armour2 = if (shield `elem` (Map.keys stack1)) then (armour shield) else 0
        boss_hp2 = if (spell==poison) then boss_hp1 else boss_hp1 - (damage spell)
        stack2 = Map.filter (>0) $ Map.insertWith (+) spell (turns spell) stack1

        --boss's turn, stack effects
        hero_hp3 = hero_hp2 + sum [heal x | x<-Map.keys stack2]
        hero_mana3 = hero_mana2 + sum [mana x | x<-Map.keys stack2]
        hero_armour3 = if (shield `elem` (Map.keys stack2)) then (armour shield) else 0
        boss_hp3 = boss_hp2 - sum [damage x | x<-Map.keys stack2]
        stack3 = Map.filter (>0) $ foldr (\x d -> Map.insertWith (+) x (-1) d) stack2 (Map.keys stack2)

        --boss damage
        hero_hp4 = hero_hp3 - maximum [boss_attack-hero_armour3, 1]

    in
        if hero_hp <= 1 then -- part 2
            let
                new_hero = (0, hero_mana1, hero_armour1)
                new_boss = (boss_hp1, boss_attack)
                new_stack = stack1
            in
                (new_hero, new_boss, new_stack, mana_used, spells_used)
        else if boss_hp1 <= 0 then
            let
                new_hero = (hero_hp1-1, hero_mana1, hero_armour1)--remove -1 for part one
                new_boss = (boss_hp1, boss_attack)
                new_stack = stack1
            in
                (new_hero, new_boss, new_stack, mana_used, spells_used)--no need to use spells if the stack finishes the boss
        else if boss_hp2 <= 0 then
            let
                new_hero = (hero_hp2-1, hero_mana2, hero_armour2)--remove -1 for part one
                new_boss = (boss_hp2, boss_attack)
                new_stack = stack2
            in
                (new_hero, new_boss, new_stack, new_mana_used, spells_used ++ [name spell])
        else if boss_hp3 <= 0 then
            let
                new_hero = (hero_hp3-1, hero_mana3, hero_armour3)--remove -1 for part one
                new_boss = (boss_hp3, boss_attack)
                new_stack = stack3
            in
                (new_hero, new_boss, new_stack, new_mana_used, spells_used ++ [name spell])
        else
            let
                new_hero = (hero_hp4-1, hero_mana3, hero_armour3)--remove -1 for part one
                new_boss = (boss_hp3, boss_attack)
                new_stack = stack3
            in
                (new_hero, new_boss, new_stack, new_mana_used, spells_used ++ [name spell])

future_states :: [Spell] -> ((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String]) -> [((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])]
future_states spells (hero, boss, damage_stack, mana_used, spells_used) = 
    let
        unavailable = [x | x<-Map.keys damage_stack, (Map.!) damage_stack x > 1]
    in
        (filter (\((x, y, z),_, _, _, _)->x>0&&y>0)) [update_state (hero, boss, damage_stack, mana_used, spells_used) x | x<-spells, not (x`elem`unavailable)]

update_all_states :: [Spell] -> [((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])] -> [((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])]
update_all_states spells states = concat [future_states spells x | x<-states]

check_win :: ((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String]) -> Bool
check_win (hero, boss, stack, mana_used, spells_used) =
    let
        (hero_hp, hero_mana, hero_armour) = hero
        (boss_hp, boss_attack) = boss
    in
        if (boss_hp <= 0) then True
        else False

hero :: (Int, Int, Int)
hero = (50, 500, 0)
boss :: (Int, Int)
boss = (0,0)--input goes here

a :: [((Int, Int, Int), (Int, Int), Map k a, Int, [String])]
a = [(hero, boss, Map.empty, 0, [])]
f :: [((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])] -> [((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])]
f x = (update_all_states spells x)

found_victory :: [((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])]
found_victory = head $ dropWhile (\x->not (True `elem` (map check_win) x)) $ (iterate f) [(hero, boss, Map.empty, 0, [])]
winning_moves :: [((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])]
winning_moves = [x | x<-found_victory, check_win x]

best_strategy :: ((Int, Int, Int), (Int, Int), Map Spell Int, Int, [String])
best_strategy = head $ sortBy (\(_,_,_,x, _) (_,_,_,y, _) -> compare x y) winning_moves