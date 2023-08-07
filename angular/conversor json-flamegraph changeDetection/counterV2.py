from collections import defaultdict

def sum_lines(input_file, output_file):
    # Dicionário para armazenar somas para cada linha
    line_sums = defaultdict(float)

    # Ler o arquivo de entrada e somar os números
    with open(input_file, 'r') as f:
        for line in f:
            line = line.strip()

            # Verificar se a linha tem um número no final
            if ' ' in line:
                main_part, number = line.rsplit(' ', 1)
                try:
                    number = float(number)
                except ValueError:
                    # Se a parte dividida não for um número, trate toda a linha como main_part e atribua 0 ao número
                    main_part = line
                    number = 0.0
            else:
                main_part = line
                number = 0.0
            
            line_sums[main_part] += number

    # Escreve as somas no arquivo de saída
    with open(output_file, 'w') as f:
        for line, summed_value in line_sums.items():
            f.write(f'{line} {summed_value}\n')

# Exemplo de uso:
file_name = 'file_4.json.txt'
sum_lines(file_name, 'output_' + file_name + '.txt')

# Esta função agora apenas calcula a soma para cada linha única e escreve os resultados no arquivo de saída.