#!/bin/bash

# Script para sincronizar variáveis de ambiente do .env para Vercel
# Primeiro remove todas as variáveis existentes, depois adiciona todas do .env

set -e

echo "🔍 Verificando variáveis existentes na Vercel..."

# Lista todas as variáveis e tenta remover
vercel env ls 2>/dev/null | grep -E "^[A-Z_]+" | while read -r line; do
    var_name=$(echo "$line" | awk '{print $1}')
    if [ -n "$var_name" ] && [[ "$var_name" =~ ^[A-Z_][A-Z0-9_]*$ ]]; then
        echo "  🗑️  Removendo: $var_name"
        vercel env rm "$var_name" production --yes 2>/dev/null || true
        vercel env rm "$var_name" preview --yes 2>/dev/null || true
        vercel env rm "$var_name" development --yes 2>/dev/null || true
    fi
done

echo "✅ Limpeza concluída!"
echo ""
echo "📤 Adicionando variáveis do .env..."

# Lê o arquivo .env e adiciona cada variável
while IFS= read -r line || [ -n "$line" ]; do
    # Ignora linhas vazias e comentários
    if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    # Remove espaços em branco
    line=$(echo "$line" | xargs)
    
    # Se a linha não tem =, pula
    if [[ ! "$line" =~ = ]]; then
        continue
    fi
    
    # Extrai nome e valor
    var_name=$(echo "$line" | cut -d'=' -f1 | xargs)
    var_value=$(echo "$line" | cut -d'=' -f2- | xargs)
    
    # Ignora se o nome está vazio
    if [ -z "$var_name" ]; then
        continue
    fi
    
    # Se o valor está vazio ou é placeholder, pula
    if [ -z "$var_value" ] || [[ "$var_value" == "your_"* ]] || [[ "$var_value" == *"XXXXXXX"* ]]; then
        echo "  ⏭️  Pulando: $var_name (placeholder ou vazio)"
        continue
    fi
    
    echo "  ➕ Adicionando: $var_name"
    
    # Adiciona para production (usa echo para passar o valor via pipe)
    echo "$var_value" | vercel env add "$var_name" production --yes 2>/dev/null || echo "    ⚠️  Erro ao adicionar $var_name"
    
done < .env

echo ""
echo "✅ Sincronização concluída!"
echo ""
echo "📋 Verificando variáveis adicionadas..."
vercel env ls
