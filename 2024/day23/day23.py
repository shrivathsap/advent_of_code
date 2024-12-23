import networkx as nx
import time

def build_graph(edges):#list of pairs (u, v)
    graph = {}
    for (u, v) in edges:
        if u in graph.keys():
            graph[u].append(v)
        else:
            graph[u] = [v]
        if v in graph.keys():
            graph[v].append(u)
        else:
            graph[v] = [u]
    return graph

def spanning_tree(graph):#assuming graph is connected
    if graph == {}:
        return {}
    else:
        nodes = list(graph.keys())
        N = len(nodes)
        tree = {}
        root = nodes[0]
        current_gen = [root]
        tree[root] = (root, 0)#parent, generation number
        visited = 1
        while current_gen != []:#gives spanning tree of a component
            next_gen = []
            for v in current_gen:
                children = [x for x in graph[v] if x not in tree.keys()]
                next_gen += children
                for child in children:
                    tree[child] = (v, tree[v][1]+1)
            current_gen = next_gen
            visited += len(current_gen)
        return tree

def all_spanning_trees(graph):
    trees = []
    while graph != {}:
        random_tree = spanning_tree(graph)
        trees.append(random_tree)
        for v in random_tree.keys():
            del graph[v]
    return trees

def base_cycles(edges):
    graph = build_graph(edges)
    trees = all_spanning_trees(graph)
    cycles = []
    for (u, v) in edges:
        cycle = []
        tree = [t for t in trees if u in t.keys()][0]
        p1 = u
        p2 = v
        cycle.append(set([u, v]))
        while (p1 != p2) and (tree[p1][0]!=p2) and (tree[p2][0]!= p1):
            cycle.append(set([tree[p1][0], p1]))
            cycle.append(set([tree[p2][0], p2]))
            p1 = tree[p1][0]
            p2 = tree[p2][0]
        if p1!=p2:
            cycle.append(set([p1, p2]))
        if len(cycle)!= 2:
            cycles.append(cycle)
    return cycles

def vertices(cycle):#cycle is a list of edges, edges are sets
    v = set([])
    for e in cycle:
        v = v.union(e)
    return v

def all_cycles(generators):#generating all cycles is too expensive :/
    first = generators[0]
    cycles = [vertices(first)]
    cycles_generated = [first]
    for cycle in generators[1:]:
        to_add = []
        for s in cycles_generated:
            intersection = [x for x in s if x in cycle]
            if intersection != []:
                new_cycle = [x for x in (s+cycle) if (x in s)^(x in cycle)]
                vertices_of_new_cycle = vertices(new_cycle)
                if vertices_of_new_cycle not in cycles:
                    to_add.append([x for x in (s+cycle) if (x in s)^(x in cycle)])
        print("here", len(cycles))
        cycles.append(vertices(cycle))
        cycles_generated.append(cycle)
        cycles += [vertices(x) for x in to_add]
        cycles_generated += to_add
    return cycles      
        
def part_one_long(edges):
    three_cycles = [x for x in all_cycles(base_cycles(edges)) if len(x) == 3]
    wanted_cycles = []
    for x in three_cycles:
        positive = False
        for y in x:
            if y[0]=='t':#starts with 't'
                positive = True
        if positive:
            wanted_cycles.append(x)
    return wanted_cycles

def part_one(edges):
    graph = build_graph(edges)
    nodes = list(graph.keys())
    tnodes = [x for x in nodes if x[0]=='t']
    cycles = []
    for n in tnodes:
        neighbours = graph[n]
        for a in neighbours:
            for b in neighbours:
                if (a, b) in edges or (b, a) in edges:
                    if set([a, b, n]) not in cycles:
                        cycles.append(set([a, b, n]))
    return cycles

with open("day23.txt", "r") as f:
    lines = f.read().split("\n")

edges = [(x[0], x[1]) for x in [y.split("-") for y in lines]]
graph = build_graph(edges)

s = time.time()
G = nx.Graph()
G.add_nodes_from(list(graph.keys()))
G.add_edges_from(edges)
all_three_cycles = list(nx.simple_cycles(G, 3))
wanted = [x for x in all_three_cycles if ('t' in [y[0] for y in x])]
max_clique = max(list(nx.find_cliques(G)), key=len)
print(len(wanted))#part one
print(",".join(sorted(max_clique)))#part two
print(time.time()-s)
    
        











            
            

    

    
    
