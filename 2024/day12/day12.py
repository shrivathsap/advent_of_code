def update(grid, rows, cols, region):
    if region == []:
        return []
    else:
        to_add = set([])
        random = region.pop()
        region.add(random)
        label = grid[random[0]][random[1]]
        for place in region:
            x = place[0]
            y = place[1]
            for n in [(x-1, y), (x, y+1), (x+1, y), (x, y-1)]:
                a = n[0]
                b = n[1]
                if (0<=a<rows) and (0<=b<cols) and (grid[a][b] == label):
                    to_add.add(n)
        return region.union(to_add)

def cost(region):
    area = len(region)
    perimeter = 0
    for place in region:
        x = place[0]
        y = place[1]
        for n in [(x-1, y), (x, y+1), (x+1, y), (x, y-1)]:
            if n not in region:
                perimeter += 1
    return area*perimeter

def sides(region, rows, cols):
    if region == set([]):
        return 0
    elif len(region) == 1:
        return 4
    else:
        to_remove = (0, 0)
        change = 0
        for place in region:
            x = place[0]
            y = place[1]
            one_step = [n for n in [(x-1, y), (x, y+1), (x+1, y), (x, y-1)] if n in region and (0<=n[0]<rows) and (0<=n[1]<cols)]
            if len(one_step) == 4:
                continue
            elif len(one_step) == 3:
                continue
            elif len(one_step) == 2:
                if (one_step[0][0]==one_step[1][0]) or (one_step[0][1]==one_step[1][1]):
                    continue
                else:
                    ver = [n for n in one_step if n[1]==y][0]
                    hor = [n for n in one_step if n[0]==x][0]
                    if (x-ver[0])*(y-hor[1]) == 1:
                        diag = [n for n in [(x-1, y+1), (x+1, y-1)] if n in region and (0<=n[0]<rows) and (0<=n[1]<cols)]
                    else:
                        diag = [n for n in [(x-1, y-1), (x+1, y+1)] if n in region and (0<=n[0]<rows) and (0<=n[1]<cols)]
                    if len(diag) == 0:
                        to_remove = place
                        change = -2
                        break
                    elif len(diag) == 1:
                        to_remove = place
                        change = 0
                        break
                    else:
                        to_remove = place
                        change = 2
                        break
            elif len(one_step) == 1:
                parent = one_step[0]
                if parent[0]==x:
                    corners = [n for n in [(parent[0]-1, parent[1]), (parent[0]+1, parent[1])]if n in region and (0<=n[0]<rows) and (0<=n[1]<cols)]
                else:
                    corners = [n for n in [(parent[0], parent[1]-1), (parent[0], parent[1]+1)]if n in region and (0<=n[0]<rows) and (0<=n[1]<cols)]
                if len(corners) == 0:
                    to_remove = place
                    change = 0
                    break
                elif len(corners) == 1:
                    to_remove = place
                    change = 2
                    break
                else:
                    to_remove = place
                    change = 4
                    break
            else:
                to_remove = place
                change = 4
                break
        region.remove(to_remove)
        return change+sides(region, rows, cols)
        
def total_cost(grid, rows, cols):
    all_pos = [(x, y) for x in range(rows) for y in range(cols)]
    all_regions = []
    while all_pos:
        seed = set([all_pos[0]])
        updated = update(grid, rows, cols, seed)
        while seed != updated:
            seed = updated
            updated = update(grid, rows, cols, seed)
        all_regions.append(seed)
        for item in seed:
            all_pos.remove(item)
    return sum([cost(x) for x in all_regions]), sum([len(x)*sides(x, rows, cols) for x in all_regions])

with open("day12.txt", "r") as f:
    grid = f.read().split("\n")
rnum = len(grid)
cnum = len(grid[0])
print(total_cost(grid, rnum, cnum))