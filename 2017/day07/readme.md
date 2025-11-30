Day 07 - Recursive Circus

I'm surprised my part solution two worked first try. We are given the data of a tree where each node has a certain weight and some number of kids. The nodes are given in a random order and for the first part we are to find the root node. Parsing is the hard part here. I parsed the data into a list of tuples of the form `(name, (weight, list_of_kids))`.

For the first part, simply form a list of all nodes, and a union of all kids and take the difference. That's it.

Now comes the second part. A node is balanced if all its kids have the same weights, but the weights of kids are computed recursively and you have to go all the way to the leaf nodes. Say vertex `a` has kids `b, c, d` and when I look at the weights, `c, d` have the same weights and this is different from `b`. If all the kids of `b` have the same weights, then the weight of `b` needs to be adjusted so that `a` becomes balanced. Part two requires us to find the correct weight for `b`: this would be `weight of c-sum(weight of kids of b)`.

Except, if `b` has kids of different weights, then the assumption is that `b` has the correct weight (there is only one node with improper weight), and one of it's kids has the wrong weight. So, we need to now find the kid with the wrong weight and figure out the correction.

To do this, I first converted my list of tuples into a `Data.Map` object. Knowing that the weights of kids would have only one term that is different or all be the same, a simple `find_repeat` lets me know the repeated values, hence the target weight for the imbalanced kid vertex. My `find_weight` function simply recursively adds the weights of the kids to the weight of the current node.

The bulk of the computation is done in the `part_two` function. Here it assumes I already know what the correct weight `root` vertex should have, checks if any of the kids are imbalanced: if not, then a subtraction gives the result, otherwise I find out what the new target weight should be and change the root to the imbalanced kid (the `wrong_kid` variable). To find the first target weight, I use `part_one` function to find out the root of the whole tree and use `find_target` to get hold of the first target weight. At first, I thought I would be stuck on the second part for a while, but it was pretty straightforward.