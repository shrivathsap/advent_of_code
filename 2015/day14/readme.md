Day 14 - Reindeer Olympics

I liked this. There are reindeers that have a speed, a duration they can fly, a rest time they need to rest for after flying for their duration. Part one is about how far the reindeers go in 2503 seconds. This is doable by hand, but easy to miscalculate. Solved this by just removing as much time as I could from 2503 (recursion) and updating a distance counter, in a way.

Part two was fun. Together with their distance, the leading reindeer(s) get a score of 1 every second and we need to find the highest score at the end of 2503 seconds. Initially, I thought that I needed to find distance+score.

I made a data type called `Reindeer` that kept track of all the information. A function `update_one` updates a single reindeer and checks whether it's flying or not, how long it has flown etc. It was a little confusing, but whatever I have works now.

Then the function `update_score` first updates each reindeer, then looks at the leading reindeer(s) and adds `1` to each of their scores. `iterate` 2503 times and look at the scores to finish. The input was 9 lines (27 numbers) so I parsed it manually.