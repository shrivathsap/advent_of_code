Day 13 - Knights of the Dinner Table

This is [Day 9](https://github.com/shrivathsap/advent_of_code/tree/main/2015/day09) of 2015's AOC with a couple differences. The set up is that there are 8 people who sit around in a circle and each gains/loses some amount of happiness depending on who their neighbour is. I still use all possible permutations. To compute the cost, I need to traverse the circle in both directions. The first part has 8! many permutations; and for the second I need to add one more person and compute. It takes a while to go through 9! many permutations.