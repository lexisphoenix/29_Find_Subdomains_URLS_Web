#!/bin/bash

# Script para crear y subir el repositorio a GitHub

REPO_NAME="29_Find_Subdomains_URLS_Web"
DESCRIPTION="Colección completa de scripts para enumeración de subdominios y URLs. Desde versiones ultra-livianas sin dependencias hasta suites completas de pentesting."

mostrar_instrucciones_manuales() {
    echo "📋 INSTRUCCIONES MANUALES:"
    echo "=========================="
    echo ""
    echo "1. Ve a https://github.com/new"
    echo "2. Nombre del repositorio: $REPO_NAME"
    echo "3. Descripción: $DESCRIPTION"
    echo "4. Elige Public o Private"
    echo "5. NO marques 'Initialize with README' (ya tenemos uno)"
    echo "6. Haz clic en 'Create repository'"
    echo ""
    echo "7. Luego ejecuta estos comandos:"
    echo ""
    echo "   git remote add origin https://github.com/TU_USUARIO/$REPO_NAME.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
    echo ""
    echo "O si prefieres usar SSH:"
    echo ""
    echo "   git remote add origin git@github.com:TU_USUARIO/$REPO_NAME.git"
    echo "   git branch -M main"
    echo "   git push -u origin main"
    echo ""
}

echo "🚀 Preparando repositorio para GitHub..."
echo ""

# Verificar si ya existe un remote
if git remote | grep -q origin; then
    echo "✅ Remote 'origin' ya existe"
    REMOTE_URL=$(git remote get-url origin)
    echo "   URL: $REMOTE_URL"
else
    echo "📝 Creando repositorio en GitHub..."
    echo ""
    echo "Opciones:"
    echo "1. Usar GitHub CLI (gh) - Si está instalado"
    echo "2. Crear manualmente en GitHub.com y luego hacer push"
    echo ""
    
    # Intentar con GitHub CLI si está disponible
    if command -v gh >/dev/null 2>&1; then
        echo "✅ GitHub CLI encontrado"
        echo "📦 Creando repositorio en GitHub..."
        
        # Verificar autenticación
        if gh auth status >/dev/null 2>&1; then
            echo "✅ Autenticado en GitHub"
            
            # Crear repositorio
            gh repo create "$REPO_NAME" \
                --public \
                --description "$DESCRIPTION" \
                --source=. \
                --remote=origin \
                --push
            
            if [ $? -eq 0 ]; then
                echo ""
                echo "✅ Repositorio creado y código subido exitosamente!"
                echo "🌐 URL: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
            else
                echo "❌ Error al crear el repositorio"
                exit 1
            fi
        else
            echo "⚠️  No estás autenticado en GitHub CLI"
            echo "   Ejecuta: gh auth login"
            echo ""
            echo "O crea el repositorio manualmente:"
            mostrar_instrucciones_manuales
        fi
    else
        echo "⚠️  GitHub CLI no está instalado"
        mostrar_instrucciones_manuales
    fi
fi

# Si ya existe el remote, hacer push
if git remote | grep -q origin; then
    echo ""
    echo "📤 Haciendo push al repositorio..."
    
    # Cambiar a main si estamos en master
    CURRENT_BRANCH=$(git branch --show-current)
    if [ "$CURRENT_BRANCH" = "master" ]; then
        git branch -M main
    fi
    
    git push -u origin main 2>/dev/null || git push -u origin master
    
    if [ $? -eq 0 ]; then
        echo "✅ Código subido exitosamente!"
        REMOTE_URL=$(git remote get-url origin)
        echo "🌐 Repositorio: $REMOTE_URL"
    else
        echo "⚠️  Error al hacer push. Verifica tus credenciales."
    fi
fi

