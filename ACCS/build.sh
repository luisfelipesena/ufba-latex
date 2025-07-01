#!/bin/bash

set -e # Para em caso de erro

echo "🛠  Compilando sol.cpp..."
g++ -o sol sol.cpp

echo "🔨 Compilando gen.cpp..."
g++ -o gen gen.cpp

echo "📂 Criando diretório de testes..."
mkdir -p tests/main

echo "🎲 Gerando casos de teste..."
./gen

echo "⚡ Processando casos..."
for i in {1..21}; do
    IN_FILE="tests/main/$(printf "%03d.in" $i)"
    OUT_FILE="tests/main/$(printf "%03d.out" $i)"
    
    ./sol < $IN_FILE > $OUT_FILE
    echo "Caso ${i}:"
    echo "  Input: $(cat $IN_FILE)"
    echo "  Output: $(cat $OUT_FILE)"
done

echo -e "\n✅ Todos os 21 casos gerados com sucesso!"
