Day 20 - Particle Swarm

Ugh, this was frustrating. My code is quite inefficient and one could probably do a lot better, but I'm too tired to make it better and I'm fine with it the way it is.

Our input has the data of initial position, velocity and acceleration of a 1000 particles in 3 space. Each second, the velocity is changed first and then the position, so after time `t`, the new datum is
```
x->x+v*t+a*t*(t+1)/2; v->v+a*t; a->a
```
Note that in the discrete case, it is not `a*t*t` for the position.

Eventually, all particles will be drifting off to infinity. For part one, we should find the particle closest to the origin in this long time range.

In the second part, every time two particles collide, they are removed from the list. Our goal is to find the number of particles that are never removed.

For parsing the input, I used regex. The position of any particle in 1D is given by a quadratic curve. Such a curve has two roots (at most) and after those two roots, the particle will drift away to infinity. For part one, for each particle I find the larger of these two roots in the `x, y, z` coordinates. Here, I completely ignored the question of complex roots and it is only now that I realize that my input was carefully designed so that all curves had at least one real root.

A `dist` function computes the Manhattan distance of a particle at time `t`. Using the `find_max` function, I can find the last time after which all particles start drifting. Then a `maximum` over the `dist`s gives the result for part one. Simple enough.

For part two, I simulated the situation. I wrote two versions of finding collisions, `will_collide` returns a Boolean value on whether two particles will collide at some given time, and `collision_time` gives the time for two particles to collide, returning `-2` if they are the same particle and `-1` if they never collide in positive time (they might have collided in the past, i.e., negative time region, but we don't care about that). Both of these are built out of their 1D counterparts (perhaps I should have used some vector package). There's a lot of lines of code here. It was really annoying to deal with the type system of Haskell and handling all the different cases (`a = 0, a = 0 && v = 0` etc.) and being careful about getting positive integral answers instead of rational etc.

There's a `tick_particle` function which moves a given particle `t` units ahead. There's a `to_delete` function which determines whether a particle collides with any of the other particles in `t` time.

Then we come to `tick` which takes in `current_stats, col_times` where `col_times` is a list of all possible collision times, and `current_stats` is the position-velocity-acceleration data of surviving particles. I look at the least positive collision time, find out which particles to delete using the `to_delete` function, then I `tick_particle` all the surviving ones that many seconds ahead. I then also modify the `col_times`.

This could be cleaned up a lot, at present `col_times` carries a lot of junk information which needs to go away along with the colliding particles, but oh well. Having computed all the pairwise collision times, I know the largest collision time and I only need to run the simulation (i.e., the `tick` function) until that time. In reality, the following situation is possible: `p1` collides with `p2` in 100 seconds and this might be the longest collision time, but at 3 seconds `p1, p3` collide and cancel out which could mean that the longest collision time reduces drastically. However, my simulation still continues until `t = 100`, which slows things down.

Regardless, after waiting a couple minutes this spits out the correct answers and that's that. Apart from the things I mentioned, I don't know how else to speed up the simulation. But what I have here is good enough for me.