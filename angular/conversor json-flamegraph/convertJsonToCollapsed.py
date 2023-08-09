import json, sys

def convert(file_name):
    with open(file_name) as f:
        data = json.load(f)
        stack = "root"
        traces = []
        walk_tree(data["buffer"], stack, traces)
    
    return traces

def save(file_name, traces):
    new_file_name = file_name + ".txt"
    with open (new_file_name, 'w') as f:
       for line in traces:
           f.write(line + "\n")

def walk_tree(data, stack, traces):
    if not data or not isinstance(data, list):
        return
    
    for element in data:
        if not element or not isinstance(element, dict):
            return
    
        if "source" in element:
            sourceName = element["source"]
            newStack = stack + ";" + sourceName
            traces.append(newStack)
        
        if (not "children" in element["directives"][0]):
                newStack = stack + ";" + element["directives"][0]["name"]
                if "changeDetection" in element["directives"][0]:
                    changeDetection = element["directives"][0]["changeDetection"]
                    if (changeDetection > 0):
                        newStack += ";changeDetection " + str(changeDetection)
                else:
                    if "lifecycle" in  element["directives"][0]:
                        if "ngDoCheck" in element["directives"][0]["lifecycle"]:
                            if (element["children"] == None):
                                newStack += ";ngDoCheck " + str(element["directives"][0]["lifecycle"]["ngDoCheck"])
                        elif "ngOnChanges" in element["directives"][0]["lifecycle"]:
                            if (element["children"] == None):
                                newStack += ";ngOnChanges " + str(element["directives"][0]["lifecycle"]["ngOnChanges"])
                
                traces.append(newStack)
        else:
            walk_tree(element["directives"], newStack, traces)
        
        if "children" in element:
            walk_tree(element["children"], newStack, traces)
        
def parse_input():
    if len(sys.argv) != 2:
        sys.exit('Example usage: python convertJsonTOCollapsed.py facebookBizTree.json')
    return sys.argv[1]

if __name__ == "__main__":
    file_name = parse_input()
    traces = convert(file_name)
    save(file_name, traces)