#!/bin/bash

# Script para crear y subir el repositorio a GitHub usando GitHub CLI

REPO_NAME="29_Find_Subdomains_URLS_Web"
DESCRIPTION="Colección completa de scripts para enumeración de subdominios y URLs. Desde versiones ultra-livianas sin dependencias hasta suites completas de pentesting."

echo "🚀 Creando y subiendo repositorio a GitHub..."
echo ""

# Verificar autenticación
if ! gh auth status >/dev/null 2>&1; then
    echo "⚠️  No estás autenticado en GitHub CLI"
    echo ""
    echo "Por favor, autentícate primero:"
    echo "   gh auth login"
    echo ""
    echo "Luego ejecuta este script nuevamente."
    exit 1
fi

echo "✅ Autenticado en GitHub"
echo "📦 Creando repositorio: $REPO_NAME"
echo ""

# Crear y subir el repositorio
gh repo create "$REPO_NAME" \
  --public \
  --description "$DESCRIPTION" \
  --source=. \
  --remote=origin \
  --push

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡Repositorio creado y código subido exitosamente!"
    echo ""
    # Obtener la URL del repositorio
    USERNAME=$(gh api user --jq .login)
    echo "🌐 URL: https://github.com/$USERNAME/$REPO_NAME"
    echo ""
    echo "📊 Puedes verificar en:"
    echo "   https://github.com/$USERNAME/$REPO_NAME"
else
    echo ""
    echo "❌ Error al crear el repositorio"
    echo ""
    echo "Posibles causas:"
    echo "  - El repositorio ya existe"
    echo "  - Problemas de permisos"
    echo "  - Problemas de conexión"
    exit 1
fi

