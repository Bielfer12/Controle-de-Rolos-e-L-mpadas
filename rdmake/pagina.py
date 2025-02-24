import fitz
import os

def split_pdf_with_last_page(input_pdf, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    doc = fitz.open(input_pdf)
    
    first_page = fitz.open()
    first_page.insert_pdf(doc, from_page=0, to_page=0)
    
    for page_num in range(1, len(doc)):  # Começa da página 1 (segunda página do PDF)
        new_pdf = fitz.open()
        new_pdf.insert_pdf(doc, from_page=page_num, to_page=page_num)  # Adiciona a página atual
        new_pdf.insert_pdf(first_page)  # Mantém a primeira página no final
        
        output_path = os.path.join(output_dir, f'page_{page_num + 1}_and_1.pdf')
        new_pdf.save(output_path)
        new_pdf.close()
        print(f'Página {page_num + 1} e 1 salva em: {output_path}')
    
    doc.close()
    first_page.close()

if __name__ == "__main__":
    input_pdf = r"C:\\PDF_CERTIFICADO\\NR06-2024-03.pdf"
    output_dir = r"C:\\PDF_CERTIFICADO\\NRF 06 - 2024 - 03"
    split_pdf_with_last_page(input_pdf, output_dir)
