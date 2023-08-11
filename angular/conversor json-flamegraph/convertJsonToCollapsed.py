import json, sys
from collections import defaultdict

def convert(file_name):
    with open(file_name) as file:
        json_data = json.load(file)
        stack = "root"
        traces = []
        walk_tree(json_data["buffer"], stack, traces)
    
    return traces

def walk_tree(data, stack, traces): 
    for element in data:
        
        # Verifica se o elemento possui um campo 'source'
        if "source" in element:
            sourceName = element["source"]
            # Cria uma nova stack acrescentando o nome da fonte
            newStack = stack + ";" + sourceName
            traces.append(newStack)
        
        # Verifica se a 'directives' do elemento nao possui 'children'
        if (not "children" in element["directives"][0]):

            # O nome do elemento esta na 'directives'
            newStack = stack + ";" + element["directives"][0]["name"]
            
            # Verifica se a 'directives' do elemento tem um campo changeDetection
            if "changeDetection" in element["directives"][0]:
                changeDetection = element["directives"][0]["changeDetection"]
                if (changeDetection > 0):
                    newStack += ";changeDetection " + str(changeDetection)
            
            traces.append(newStack)
            
        else:
            # Se a 'directives' do elemento contem 'children', processa recursivamente
            walk_tree(element["directives"], newStack, traces)
        
        # Se o elemento tem um campo 'children', processa esses filhos recursivamente
        if "children" in element:
            walk_tree(element["children"], newStack, traces)

        
def parse_input():
    if len(sys.argv) != 2:
        sys.exit('Exemplo de uso: python convertJsonTOCollapsed.py file.json')
    return sys.argv[1]

def process_and_sum_lines(traces, output_file_name):
    line_sums = defaultdict(float)
    
    for line in traces:
        line = line.strip() # Remove a quebra de linha no final
        
        parts = line.split(';')
        
        # Verifica se a ultima parte eh um numero
        if any(character.isdigit() for character in parts[-1]):
            value = float(parts.pop().split(' ')[1])
        else:
            value = 0
        
        # Remove os segmentos "changeDetection" do meio
        processed_parts = [part for part in parts if not 'changeDetection' in part]
        
        processed_line = ';'.join(processed_parts)
        
        line_sums[processed_line] += value

    with open(output_file_name, 'w') as file:
        for line, summed_value in line_sums.items():
            file.write(f'{line} {summed_value:.6f}\n')

if __name__ == "__main__":
    file_name = parse_input()
    traces = convert(file_name)
    process_and_sum_lines(traces, 'output.txt')