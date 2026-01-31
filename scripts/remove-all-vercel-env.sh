#!/bin/bash

# Script para remover TODAS as variáveis de ambiente da Vercel

set -e

echo "🗑️  Removendo TODAS as variáveis de ambiente do projeto neo-flowoff-pwa..."
echo ""

# Obtém lista de variáveis únicas (pula linhas de cabeçalho e pega primeira coluna)
VARS=$(vercel env ls 2>/dev/null | awk 'NR>4 && NF>0 && $1 !~ /^Common/ && $1 !~ /^$/ {print $1}' | sort -u)

if [ -z "$VARS" ]; then
    echo "✅ Nenhuma variável encontrada!"
    exit 0
fi

COUNT=$(echo "$VARS" | wc -l | xargs)
echo "📋 Encontradas $COUNT variáveis únicas para remover"
echo ""

# Remove cada variável de todos os ambientes
REMOVED=0
while IFS= read -r var_name; do
    if [ -n "$var_name" ] && [[ "$var_name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
        echo "  🗑️  Removendo: $var_name"
        
        # Remove de todos os ambientes
        vercel env rm "$var_name" production --yes 2>/dev/null && REMOVED=$((REMOVED+1)) || true
        vercel env rm "$var_name" preview --yes 2>/dev/null || true
        vercel env rm "$var_name" development --yes 2>/dev/null || true
    fi
done <<< "$VARS"

echo ""
echo "✅ Removidas $REMOVED variáveis!"
echo ""
echo "📋 Verificando..."
vercel env ls
