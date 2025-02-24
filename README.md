# 📌 Controle de Rolos e Lâmpadas

📢 **Sobre o Projeto**  
Controle de Rolos e Lâmpadas é um sistema desenvolvido em **ADVPL**, projetado para facilitar a gestão de itens e manutenções. O projeto conta com diversas funcionalidades essenciais:

✅ Cadastramento de itens 📋  
✅ Cadastramento de manutenção 🛠️  
✅ Geração de relatórios 📊  

🛠️ **Objetivo**  
O sistema tem como foco ser um controlador eficiente de manutenção de rolos e lâmpadas, permitindo consultas inteligentes para auxiliar na gestão. Além disso, conta com diversas subfunções integradas para otimizar os processos.  

---

## 🚀 Tecnologias Utilizadas
- **ADVPL** (Linguagem principal)
- **Protheus** (Ambiente de execução)
- **Banco de Dados SQL** (Para armazenamento)

## 📜 Código Exemplo (ADVPL)
```advpl
User Function ControleRolosLamps()
    Local cTitulo := "Controle de Rolos e Lâmpadas"
    Local aItens := {"Impressora 1", "Estação 2", "Rolos 3", "Lampadas 3"}

    ConOut(cTitulo)
    For Each cItem In aItens
        ConOut("Item: " + cItem)
    Next
Return Nil
```

## 📖 Indice
⌨️ - [Fonte](https://github.com/Bielfer12/Controle-de-Rolos-e-Lampadas/blob/casa/rdmake/CONTROL.prw) - Código do projeto 
<br>
📃 - [Documentação](https://github.com/Bielfer12/Controle-de-Rolos-e-Lampadas/blob/casa/Documentos/Documentao.txt) - Documentaçõa do projeto
