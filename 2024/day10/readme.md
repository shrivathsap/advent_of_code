Day 10 - Hoof It

This was easy. The goal is to find (distinct) paths from 0 to 9 in a grid with each step having size 1. I took the grid, found the 0s. I wrote a function that takes in a position and gives its neighbours whose size is one more.

A simple list comprehension together with concatenation does the job. Part 2 needed distinct paths and this amounts to removing a few letters from the code.