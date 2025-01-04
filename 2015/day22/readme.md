Day 22 - Wizard Simulator 20XX

This was similar to [Day 21](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day21) but with a lot more rules to keep track of, but it was fun to code. The input is two numbers, so there's no parsing.

This time we are playing as a wizard and we have 5 spells: magic missile, drain, shield, poison, recharge and they each cost some mana to use and last for some turns. Unlike Day 21, at each turn we have a choice to make. The goal is to figure out what the least mana we can use and still win.

Shield, poison and recharge last a few turns and aren't activated immediately. We start first. Say, we use "poison". Then it's the boss's turn: we recieves some damage (depends on our armour - "shield" increases our armour), but because "poison" is active, the boss also takes some damage, and the timer on "poison" decreases by 1. Then it's our turn and may be we want to use "recharge", but before we use it, "poison" affects the boss again and its timer decreases. Then we use "recharge" and it is pushed on to the "stack". And so on.

If an effect is currently active, then we cannot use it, but if "poison" ends at our turn, then we can use it again. This is handled in `future_states` by filtering out those effects that have `>1` turns left.

I don't know if there's an intelligent way to solve this, so I used brute force. I start with a "state" that looks like
```
((hero_hp, hero_mana, hero_armour), (boss_hp, boss_attack), damage_stack, mana_used, spells_used)
```
where `damage_stack` is all the effects still waiting to happen at each turn. Then I update it using the `update_state` function.

The `update_state` function goes through 4 stages: first the effects of whatever is on the stack (this is handled with the whole `hero_hp1, boss_hp1, ...` stuff), then the effect of the player's current spell (`hero_hp2, boss_hp2, ...`), then it's the boss's turn but the effects of active spells is handled first (`hero_hp3, boss_hp3, ...`) and lastly, the boss's damage which only affects `hero_hp3` and changes it to `hero_hp4`.

Then, I check if the boss died at one of these 4 stages and if so, I return the stats for that particular stage, otherwise I return the stats after all 4 stages. Then it's the player's turn again.

There were two mistakes I made here.

For the first part, I was getting too low of an answer - which means that either I was making an accounting error or the boss was dying too fast. The issue was that I was dealing damage with "poison" the moment it was activated, thus the `if (spell==poison) then boss_hp1 else boss_hp1 - (damage spell)` line.

For the second part, before anything happens, the player loses 1hp at each of the player's turn. I figured it was just a matter of adding a `-1` everywhere: but this has to happen before anything heals the player. It was just 4 extra lines. But my answer was too high. This either meant I was too harsh on the player or too lenient on the boss somehow.

After being unable to figure out what was going on, I added the `spells_used` list so that I can see which spells were used in the "best_strategy" and walk through it step-by-step. That's when I noticed that just before the boss's turn I was using the `damage_stack` stack of effects instead of `stack2`. So, had the player used "poison", then it was affecting the boss one turn too late! Changing that gave me the right answer.

My code is long and somewhat messy, but I like it. This was fun to code, but annoying to figure out what went wrong.