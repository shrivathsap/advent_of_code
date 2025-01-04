import Data.List

add :: Num a => [a] -> [a] -> [a]
add [a,b,c] [x,y,z] = [a+x, b+y, c+z]

can_win :: (Int, Int, Int) -> (Int, Int, Int) -> Bool
can_win (boss_hp, boss_attack, boss_defense) (hero_hp, hero_attack, hero_defense) =
    let
        att = maximum [hero_attack-boss_defense, 1]
        damage = maximum [boss_attack-hero_defense, 1]
    in
        if boss_hp <= 0 then True
        else if hero_hp <= 0 then False
        else can_win (boss_hp-att, boss_attack, boss_defense) (hero_hp-damage, hero_attack, hero_defense)

main :: IO ()
main = do
    stats <- lines <$> readFile "stats.txt"
    let
        ---start parsing
        weapons = drop 1 (takeWhile (/= "") stats)
        armours = drop 1 (takeWhile (/= "") (drop (2+length weapons) stats))
        rings = drop 1 (takeWhile (/= "") (drop (4+length weapons + length armours) stats))
        weapon_dict = [(map (read::String->Int))[(words x)!!1, (words x)!!2, (words x)!!3]|x<-weapons]
        armour_dict = [(map (read::String->Int))[(words x)!!1, (words x)!!2, (words x)!!3]|x<-armours]
        ring_dict = [(map (read::String->Int))[(words x)!!2, (words x)!!3, (words x)!!4]|x<-rings]
        pairs = concat [[add x y | y<-ring_dict, y/=x] |x<-ring_dict]
        weapon_armour = concat [[add x y|y<-[[0,0,0]]++armour_dict]|x<-weapon_dict]
        all_combinations = concat [[add x y |y<-([[0,0,0]]++ring_dict++pairs)]|x<-weapon_armour]
        --end parsing

        hero_hp = 100

        --input goes here
        boss_hp = 0
        boss_attack = 0
        boss_armour = 0

        winning_combinations = sortBy (\a b -> compare (a!!0) (b!!0)) [x | x<-all_combinations, can_win (boss_hp, boss_attack, boss_armour) (hero_hp, x!!1, x!!2)]
        losing_combinations = sortBy (\a b -> compare (a!!0) (b!!0)) [x | x<-all_combinations, not(can_win (boss_hp, boss_attack, boss_armour) (hero_hp, x!!1, x!!2))]
    print(head winning_combinations)
    print(last losing_combinations)