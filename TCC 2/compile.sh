#!/bin/bash
# Script de compilação limpa do artigo LaTeX
# Uso: ./compile.sh

echo "🧹 Limpando arquivos auxiliares..."
rm -f main.aux main.bbl main.blg main.log main.out main.synctex.gz

echo "📝 Compilação 1/4 - Primeira passagem..."
pdflatex -interaction=nonstopmode main.tex > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "❌ Erro na primeira compilação! Veja main.log"
    exit 1
fi

echo "📚 Compilação 2/4 - Processando bibliografia..."
bibtex main > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "⚠️  Warning no BibTeX (pode ser normal)"
fi

echo "📝 Compilação 3/4 - Segunda passagem..."
pdflatex -interaction=nonstopmode main.tex > /dev/null 2>&1

echo "📝 Compilação 4/4 - Passagem final..."
pdflatex -interaction=nonstopmode main.tex > /dev/null 2>&1

if [ -f main.pdf ]; then
    PAGES=$(pdfinfo main.pdf 2>/dev/null | grep Pages | awk '{print $2}')
    SIZE=$(ls -lh main.pdf | awk '{print $5}')
    echo ""
    echo "✅ Compilação concluída com sucesso!"
    echo "📄 PDF gerado: main.pdf ($SIZE, $PAGES páginas)"
    echo ""

    # Verificar erros (ignorando avisos normais de pacotes e fontes)
    ERRORS=$(grep -i "error\|undefined citation\|undefined reference" main.log | grep -v "infwarerr\|Font.*undefined" | wc -l | tr -d ' ')
    if [ "$ERRORS" -eq 0 ]; then
        echo "✨ Zero erros detectados!"
    else
        echo "⚠️  $ERRORS avisos encontrados (veja main.log)"
    fi
else
    echo "❌ Falha ao gerar PDF!"
    exit 1
fi
