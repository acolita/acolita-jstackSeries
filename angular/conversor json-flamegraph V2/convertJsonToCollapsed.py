import json, sys

def convert(file_name):
    #file_name = parse_input()

    with open(file_name) as f:
        data = json.load(f)
        stack = "root"
        traces = []
        walk_tree(data, stack, traces)
    
    return traces

def save(file_name, traces):
    new_file_name = file_name + ".txt"
    with open (new_file_name, 'w') as f:
       for line in traces:
           #print(line)
           f.write(line + "\n")

def walk_tree(data, stack, traces):
    if not data or not isinstance(data, dict):
        return

    for key, value in data.items():
        if (key == "directives" and not("children" in value[0])):
            newStack = stack + ";" + value[0]["name"]
            #if (value["name"] == children)
            num = 0
            if "lifecycle" in  value[0]:
                if "ngDoCheck" in value[0]["lifecycle"]:
                    #newStack += ";" + "ngDoCheck"
                    newStack = newStack.replace("root", "ngDoCheck")
                    num = value[0]["lifecycle"]["ngDoCheck"]
                elif "ngOnChanges" in value[0]["lifecycle"]:
                    #newStack += ";" + "ngOnChanges"
                    newStack = newStack.replace("root", "ngOnChanges")
                    num = value[0]["lifecycle"]["ngOnChanges"]

            newStack += " " + str(num)
            traces.append(newStack)
        elif (key == "children"):
            newStack = stack + ";" + key
            #traces.append(newStack)
            for i in value:
                walk_tree(i, newStack, traces)
        elif (key == "directives"):
            newStack = stack + ";" + key
            traces.append(newStack)
            for i in value:
                walk_tree(i, newStack, traces)

def parse_input():
    if len(sys.argv) != 2:
        sys.exit('Example usage: python convertJsonTOCollapsed.py facebookBizTree.json')

    return sys.argv[1]

if __name__ == "__main__":
    file_name = parse_input()
    traces = convert(file_name)
    save(file_name, traces)