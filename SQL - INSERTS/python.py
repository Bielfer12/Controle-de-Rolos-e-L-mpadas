import os

# Caminho do arquivo de entrada
input_file_path = r"C:\Controle_de_rolos_e_lampadas(codigo)\Documentos\MANUTLAMPADA_INSERTS.SQL"

# Caminho do arquivo de saída
output_file_path = r"C:\Controle_de_rolos_e_lampadas(codigo)\Documentos\mnutlampadas_formatado.sql"

# Dicionário de mapeamento de códigos para nomes de impressoras
impressoras = {
    '1': 'DRENT 01',
    '2': 'DRENT 02',
    '3': 'CERUTTI',
}

# Dicionário de mapeamento de códigos para nomes de lâmpadas
lampadas = {
    '1': 'LAMPADA 01',
    '2': 'LAMPADA 02',
    '3': 'LAMPADA 03',
    '4': 'LAMPADA 01',
    '5': 'LAMPADA 02',
    '6': 'LAMPADA 03',
    '7': 'LAMPADA 04',
    '8': 'LAMPADA 05',
    '9': 'LAMPADA 06',
   '10': 'LAMPADA 07',
   '11': 'LAMPADA 1',
   '12': 'LAMPADA 2',
   '13': 'LAMPADA 3',
   '14': 'LAMPADA 4',
   '15': 'LAMPADA 5',
   '16': 'LAMPADA 6',
   '17': 'LAMPADA 7'
}

# Função para processar o arquivo e substituir os códigos pelos nomes das impressoras e lâmpadas
def processar_arquivo(input_path, output_path):
    if not os.path.exists(input_path):
        print(f"Arquivo de entrada não encontrado: {input_path}")
        return

    with open(input_path, 'r', encoding='latin-1') as infile, open(output_path, 'w', encoding='latin-1') as outfile:
        for line in infile:
            if line.startswith("INSERT INTO ZM2"):
                # Encontrar a parte VALUES e dividir os valores
                parts = line.split("VALUES")
                if len(parts) > 1:
                    valores = parts[1].strip().strip("();").split(",")
                    # Substituir o código da impressora pelo nome correspondente
                    impressora_codigo = valores[2].strip().strip("'")
                    if impressora_codigo in impressoras:
                        valores[2] = f" '{impressoras[impressora_codigo]}'"
                    # Substituir o código da lâmpada pelo nome correspondente
                    lampada_codigo = valores[5].strip().strip("'")
                    if lampada_codigo in lampadas:
                        valores[5] = f" '{lampadas[lampada_codigo]}'"
                    # Recriar a linha com os valores substituídos
                    line = f"{parts[0]} VALUES ({','.join(valores)});\n"
            outfile.write(line)

# Processar o arquivo
processar_arquivo(input_file_path, output_file_path)

print(f"Arquivo formatado foi criado em: {output_file_path}")

# import pandas as pd

# # Caminho do arquivo de entrada
# input_file_path = r"C:\Controle_de_rolos_e_lampadas(codigo)\Documentos\ManutLampada.xlsx"

# # Caminho do arquivo de saída
# output_file_path = r"C:\Controle_de_rolos_e_lampadas(codigo)\Documentos\ManutLampada_Inserts.sql"

# # Ler o arquivo Excel
# df = pd.read_excel(input_file_path)

# # Verificar os nomes das colunas no DataFrame
# colunas = df.columns.tolist()

# # Inicializar o RECNO
# recno = 1

# # Abrir o arquivo de saída para escrita
# with open(output_file_path, 'w', encoding='utf-8') as outfile:
#     # Iterar sobre as linhas do DataFrame
#     for index, row in df.iterrows():
#         # Montar o comando SQL INSERT
#         valores = [f"'{str(value).replace("'", "''")}'" if pd.notna(value) else 'NULL' for value in row]
#         insert_statement = f"INSERT INTO ZM2990 ({', '.join(colunas)}, R_E_C_N_O_) VALUES ({', '.join(valores)}, {recno});\n"
#         # Escrever o comando no arquivo de saída
#         outfile.write(insert_statement)
#         # Incrementar o RECNO
#         recno += 1

# print(f"Arquivo de comandos INSERT foi criado em: {output_file_path}")


# import re

# # Caminho do arquivo de entrada
# input_file_path = r'C:\Controle_de_rolos_e_lampadas(codigo)\Documentos\MANUTLAMPADA_INSERTS.SQL'
# # Caminho do arquivo de saída
# output_file_path = r'C:\Controle_de_rolos_e_lampadas(codigo)\Documentos\ManutLampada_inserts_modificado.sql'

# # Ler o conteúdo do arquivo de entrada
# with open(input_file_path, 'r', encoding='utf-8') as file:
#     content = file.read()

# # Encontrar todas as datas no formato YYYY-MM-DD HH:MM:SS e YYYYMMDD HH:MM:SS e remover o horário
# content = re.sub(r'(\d{4}-\d{2}-\d{2}|\d{8}) \d{2}:\d{2}:\d{2}', r'\1', content)

# # Escrever o conteúdo modificado no arquivo de saída
# with open(output_file_path, 'w', encoding='utf-8') as file:
#     file.write(content)

# print("Substituições concluídas com sucesso!")