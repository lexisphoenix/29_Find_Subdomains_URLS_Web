#!/bin/bash
URL_INPUT="https://typerepublic.com/"

# Agregar directorios comunes de herramientas al PATH
export PATH="$PATH:$HOME/go/bin:$HOME/.local/bin"

# Extraer dominio limpio (sin https:// y sin barra final)
DOMINIO=$(echo "$URL_INPUT" | sed -E 's|^https?://||' | sed 's|/$||' | sed 's|/.*||')
# Crear nombre de archivo seguro (reemplazar solo caracteres problemáticos, mantener puntos)
DOMINIO_LIMPIO=$(echo "$DOMINIO" | sed 's/[^a-zA-Z0-9._-]/_/g' | sed 's|__*|_|g' | sed 's|^_||' | sed 's|_$||')

echo "🎯 Escaneo completo de $URL_INPUT..."
echo "=================================="

# Verificar herramientas instaladas
echo "🔧 Verificando herramientas..."
if command -v subfinder >/dev/null 2>&1; then
    echo "✅ subfinder encontrado"
else
    echo "❌ subfinder no instalado"
fi

if command -v assetfinder >/dev/null 2>&1; then
    echo "✅ assetfinder encontrado"
else
    echo "❌ assetfinder no instalado"
fi

if command -v waybackurls >/dev/null 2>&1; then
    echo "✅ waybackurls encontrado"
else
    echo "❌ waybackurls no instalado"
fi

if command -v gau >/dev/null 2>&1; then
    echo "✅ gau encontrado"
else
    echo "❌ gau no instalado"
fi

if command -v katana >/dev/null 2>&1; then
    echo "✅ katana encontrado"
else
    echo "❌ katana no instalado"
fi

# Subdominios
echo ""
echo "🔍 Buscando subdominios..."
> subs_temp.txt  # Limpiar archivo temporal

if command -v subfinder >/dev/null 2>&1; then
    subfinder -d "$DOMINIO" -silent 2>/dev/null | sort -u >> subs_temp.txt
fi

if command -v assetfinder >/dev/null 2>&1; then
    assetfinder --subs-only "$DOMINIO" 2>/dev/null >> subs_temp.txt
fi

# URLs
echo "🔗 Buscando URLs..."
> urls_temp.txt  # Limpiar archivo temporal

if command -v waybackurls >/dev/null 2>&1; then
    waybackurls "$DOMINIO" 2>/dev/null >> urls_temp.txt
fi

if command -v gau >/dev/null 2>&1; then
    gau "$DOMINIO" 2>/dev/null >> urls_temp.txt
fi

if command -v katana >/dev/null 2>&1; then
    katana -u "$URL_INPUT" -silent 2>/dev/null >> urls_temp.txt
fi

# Procesar resultados
sort -u subs_temp.txt > "${DOMINIO_LIMPIO}_subdominios.txt"
sort -u urls_temp.txt > "${DOMINIO_LIMPIO}_urls.txt"

# Mostrar resultados
echo ""
echo "📊 RESULTADOS FINALES:"
echo "=================================="
SUBDOMINIOS_COUNT=$(wc -l < "${DOMINIO_LIMPIO}_subdominios.txt" 2>/dev/null || echo 0)
URLS_COUNT=$(wc -l < "${DOMINIO_LIMPIO}_urls.txt" 2>/dev/null || echo 0)
echo "🌐 Subdominios encontrados: $SUBDOMINIOS_COUNT"
echo "🔗 URLs encontradas: $URLS_COUNT"

# Mostrar algunos ejemplos de URLs
echo ""
echo "📍 Ejemplos de URLs encontradas:"
if [ -f "${DOMINIO_LIMPIO}_urls.txt" ] && [ -s "${DOMINIO_LIMPIO}_urls.txt" ]; then
    cat "${DOMINIO_LIMPIO}_urls.txt" | grep -v "\.\(css\|js\|png\|jpg\|jpeg\|gif\)" | head -10
else
    echo "   No se encontraron URLs"
fi

# Buscar páginas específicas
echo ""
echo "🔍 Páginas específicas encontradas:"
if [ -f "${DOMINIO_LIMPIO}_urls.txt" ] && [ -s "${DOMINIO_LIMPIO}_urls.txt" ]; then
    for pagina in contacto portfolio blog about shop services; do
        count=$(grep -c "$pagina" "${DOMINIO_LIMPIO}_urls.txt" 2>/dev/null || echo 0)
        echo "   📄 /$pagina/: $count URLs"
    done
fi

# Limpiar temporales
rm -f subs_temp.txt urls_temp.txt

echo ""
echo "✅ Análisis completado!"
if [ -f "${DOMINIO_LIMPIO}_subdominios.txt" ]; then
    echo "   📁 ${DOMINIO_LIMPIO}_subdominios.txt (subdominios)"
fi
if [ -f "${DOMINIO_LIMPIO}_urls.txt" ]; then
    echo "   📁 ${DOMINIO_LIMPIO}_urls.txt (todas las URLs)"
fi
