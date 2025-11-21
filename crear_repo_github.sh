#!/bin/bash

# Script para crear repositorio en GitHub usando la API

REPO_NAME="29_Find_Subdomains_URLS_Web"
DESCRIPTION="Colección completa de scripts para enumeración de subdominios y URLs. Desde versiones ultra-livianas sin dependencias hasta suites completas de pentesting."

echo "🚀 Creando repositorio en GitHub..."
echo ""

# Verificar si hay un token de GitHub
if [ -z "$GITHUB_TOKEN" ]; then
    echo "⚠️  No se encontró GITHUB_TOKEN en las variables de entorno"
    echo ""
    echo "Para crear el repositorio automáticamente, necesitas un Personal Access Token:"
    echo "1. Ve a: https://github.com/settings/tokens"
    echo "2. Crea un nuevo token con permisos 'repo'"
    echo "3. Ejecuta: export GITHUB_TOKEN=tu_token"
    echo "4. Luego ejecuta este script nuevamente"
    echo ""
    echo "O crea el repositorio manualmente:"
    echo "1. Ve a https://github.com/new"
    echo "2. Nombre: $REPO_NAME"
    echo "3. Descripción: $DESCRIPTION"
    echo "4. Luego ejecuta:"
    echo "   git remote add origin https://github.com/TU_USUARIO/$REPO_NAME.git"
    echo "   git push -u origin main"
    exit 1
fi

# Obtener el usuario de GitHub
USERNAME=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep -o '"login":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$USERNAME" ]; then
    echo "❌ Error: No se pudo obtener el usuario de GitHub. Verifica tu token."
    exit 1
fi

echo "✅ Usuario de GitHub: $USERNAME"
echo "📦 Creando repositorio: $REPO_NAME"
echo ""

# Crear el repositorio
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{
    \"name\": \"$REPO_NAME\",
    \"description\": \"$DESCRIPTION\",
    \"private\": false
  }")

HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "201" ]; then
    echo "✅ Repositorio creado exitosamente!"
    echo ""
    
    # Agregar remote y hacer push
    if ! git remote | grep -q origin; then
        git remote add origin "https://github.com/$USERNAME/$REPO_NAME.git"
        echo "✅ Remote 'origin' agregado"
    fi
    
    echo "📤 Subiendo código..."
    git push -u origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ ¡Repositorio creado y código subido exitosamente!"
        echo "🌐 URL: https://github.com/$USERNAME/$REPO_NAME"
    else
        echo "⚠️  Error al hacer push. Verifica tus credenciales."
        echo "   Puedes intentar manualmente:"
        echo "   git push -u origin main"
    fi
elif [ "$HTTP_CODE" = "422" ]; then
    echo "⚠️  El repositorio ya existe o hay un conflicto"
    echo ""
    echo "Si el repositorio ya existe, puedes hacer push directamente:"
    echo "   git remote add origin https://github.com/$USERNAME/$REPO_NAME.git"
    echo "   git push -u origin main"
else
    echo "❌ Error al crear el repositorio (HTTP $HTTP_CODE)"
    echo "$BODY" | head -10
fi

