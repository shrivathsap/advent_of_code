--Day 15 - Science for Hungry People
--Small input, parsed everything by hand and figured out what bounds to need to be satisfied in order to maximize
--something. There were just 3 variables (the 4th is just 100-a-b-d), so 1000000 length loop to check which are possible
---second part add another constraint. Maximum of scores, scores_two are the two answers.
possible = [[a,b,100-a-b-d,d]|a<-[0..100], b<-[0..100], d<-[0..100], d<=5*b, (100-a-b-d)<=5*d, (2*a+3*b)<=5*(100-a-b-d)]
scores = [(2*a)*(5*b-d)*(5*d-c)*(5*c-2*a-3*b)|[a,b,c,d]<-possible]
scores_two = [(2*a)*(5*b-d)*(5*d-c)*(5*c-2*a-3*b)|[a,b,c,d]<-possible, (3*a+3*b+8*c+8*d)==500]