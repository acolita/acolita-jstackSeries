from collections import defaultdict

def process_and_sum_lines(input_file, output_file):
    # Inicializa um dicionário para armazenar os valores somados para as linhas
    line_sums = defaultdict(float)
    
    # Lê o arquivo de entrada, processa e soma as linhas
    with open(input_file, 'r') as f:
        for line in f:
            line = line.strip() # Remove a quebra de linha no final
            
            # Divide a linha em partes
            parts = line.split(';')
            
            # Verifica se a última parte é um número (valor a ser somado)
            if any(c.isdigit() for c in parts[-1]):
                value = float(parts.pop().split(' ')[1])
            else:
                value = 0
            
            # Filtra os segmentos "changeDetection: <número>"
            processed_parts = [part for part in parts if not 'changeDetection' in part]
            
            # Cria a linha processada
            processed_line = ';'.join(processed_parts)
            
            # Adiciona o valor à soma para essa linha
            line_sums[processed_line] += value

    # Escreve as linhas processadas e seus valores somados no arquivo de saída
    with open(output_file, 'w') as f:
        for line, summed_value in line_sums.items():
            f.write(f'{line} {summed_value:.6f}\n')

# Exemplo de uso (para fins de demonstração):
process_and_sum_lines('file_1.json.txt', 'output.txt')