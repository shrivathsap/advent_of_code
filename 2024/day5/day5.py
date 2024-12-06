def char_to_int(list_of_chars):
    return [int(x) for x in list_of_chars]

def middle_of(list_of_nums):
    return list_of_nums[(len(list_of_nums)-1)//2] if len(list_of_nums)%2 == 1 else 0

#convert a list of rules to a dictionary
#to each number, associate a list of numbers that should be above it
def list_to_dict(rule_list):
    rule_dict = {}
    for item in rule_list:
        first = item[0]
        above = []
        for another_item in rule_list:
            if another_item[0]==first:
                above.append(another_item[1])
        rule_dict[first] = above
    return rule_dict

def intersect(list1, list2):#"not []" evaluates to True...funny
    return not not [x for x in list1 if x in list2]

#if the number is not in the rule_dictionary, then it doesn't matter where it is
#else, look at things appearing before it and check if any of those were supposed to be after it
#this is done by checking whether the list till that number intersects the
#corresponding associated "larger nums" as dictated by rule_dictionary
def is_safe(list_of_nums, rule_dictionary):#nice list comprehension
    flags = [(intersect(list_of_nums[:i], rule_dictionary[list_of_nums[i]]) if (list_of_nums[i] in rule_dictionary.keys()) else False)
             for i in range(len(list_of_nums))]
    return not (True in flags)

#quick sort type recursive sort based on the dictionary
#if list is empty, return []
#else, take the last element and see whether it has any rules, if not, sort everything except the last element
#if yes, then see the things before it, move some up, move some down do recursive sorts
#might not be the best way, but it did the job
#i should have done this for part 1 as well, might have saved some time for part 2, oh well
def sort(list_of_nums, rule_dictionary):
    if not list_of_nums:
        return []
    else:
        last_item = list_of_nums[-1]
        if last_item not in rule_dictionary.keys():
            return sort(list_of_nums[:-1], rule_dictionary)+[last_item]
        else:
            move_up = [x for x in list_of_nums[:-1] if x in rule_dictionary[last_item]]
            rest = [x for x in list_of_nums[:-1] if x not in move_up]
            lower = sort(rest, rule_dictionary)
            upper = sort(move_up, rule_dictionary)
            return lower+[last_item]+upper

with open("day5.txt", "r") as f:
    all_lines = f.read().split("\n")

split_point = all_lines.index("")
rule_set = [char_to_int(x.split("|")) for x in all_lines[:split_point]]
pages = [char_to_int(x.split(",")) for x in all_lines[split_point+1:]]
rule_dict = list_to_dict(rule_set)
safe_pages = [x for x in pages if is_safe(x, rule_dict)]
unsafe_pages = [x for x in pages if x not in safe_pages]
sorted_unsafe = [sort(x, rule_dict) for x in unsafe_pages]
middles = [middle_of(page) for page in safe_pages]
unsafe_middles = [middle_of(page) for page in sorted_unsafe]
print(sum(middles))
print(sum(unsafe_middles))
