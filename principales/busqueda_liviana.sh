#!/bin/bash

# ============================================
# SCRIPT LIVIANO - Sin dependencias externas
# Solo usa herramientas del sistema: curl, grep, sed, awk
# ============================================

DOMINIO="${1:-example.com}"

if [ -z "$DOMINIO" ]; then
    echo "❌ Uso: $0 <dominio>"
    echo "   Ejemplo: $0 example.com"
    exit 1
fi

# Limpiar dominio (sin http/https)
DOMINIO=$(echo "$DOMINIO" | sed 's|^https\?://||' | sed 's|/$||' | sed 's|/.*||')
DOMINIO_LIMPIO=$(echo "$DOMINIO" | sed 's/[^a-zA-Z0-9._-]/_/g')

echo "🔍 Búsqueda LIVIANA de URLs y subdominios para: $DOMINIO"
echo "=================================================="
echo "📦 Sin dependencias externas (solo herramientas del sistema)"
echo ""

# Crear directorio de resultados
DIR_RESULTADOS="resultados_${DOMINIO_LIMPIO}"
mkdir -p "$DIR_RESULTADOS"

# ============================================
# 1. SUBDOMINIOS - APIs públicas gratuitas
# ============================================
echo "🌐 Buscando subdominios..."

> "$DIR_RESULTADOS/subs_temp.txt"

# API de crt.sh (Certificate Transparency)
echo "  📡 Consultando crt.sh..."
curl -s "https://crt.sh/?q=%25.${DOMINIO}&output=json" 2>/dev/null | \
    grep -oP '"name_value":\s*"\K[^"]*' | \
    sed 's/\\n/\n/g' | \
    grep -E "^[a-zA-Z0-9.-]+\.${DOMINIO}$" | \
    sort -u >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null

# API de SecurityTrails (limitada pero funciona)
echo "  📡 Consultando SecurityTrails (público)..."
curl -s "https://securitytrails.com/domain/${DOMINIO}/subdomains" 2>/dev/null | \
    grep -oE "[a-zA-Z0-9.-]+\.${DOMINIO}" | \
    sort -u >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null

# Wayback Machine para subdominios
echo "  📡 Consultando Wayback Machine..."
curl -s "http://web.archive.org/cdx/search/cdx?url=*.${DOMINIO}/*&output=json&collapse=urlkey" 2>/dev/null | \
    grep -oE "https?://[a-zA-Z0-9.-]+\.${DOMINIO}[^\"]*" | \
    sed 's|https\?://||' | \
    sed 's|/.*||' | \
    sort -u >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null

# DNS público (usando servicios DNS públicos)
echo "  📡 Consultando DNS públicos..."
# Intentar resolver subdominios comunes
for sub in www mail ftp admin test dev staging api cdn blog shop store; do
    host "${sub}.${DOMINIO}" 8.8.8.8 2>/dev/null | grep -q "has address" && echo "${sub}.${DOMINIO}" >> "$DIR_RESULTADOS/subs_temp.txt"
done

# Procesar subdominios
sort -u "$DIR_RESULTADOS/subs_temp.txt" > "$DIR_RESULTADOS/subdominios.txt"
SUBS_COUNT=$(wc -l < "$DIR_RESULTADOS/subdominios.txt" 2>/dev/null || echo 0)
echo "  ✅ Encontrados: $SUBS_COUNT subdominios"

# ============================================
# 2. URLs - APIs públicas y crawling básico
# ============================================
echo ""
echo "🔗 Buscando URLs..."

> "$DIR_RESULTADOS/urls_temp.txt"

# Wayback Machine API
echo "  📚 Consultando Wayback Machine..."
curl -s "http://web.archive.org/cdx/search/cdx?url=${DOMINIO}/*&output=text&fl=original&collapse=urlkey" 2>/dev/null | \
    sort -u >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null

# Intentar obtener URLs del sitemap
echo "  🗺️  Buscando sitemap.xml..."
curl -s "https://${DOMINIO}/sitemap.xml" 2>/dev/null | \
    grep -oE '<loc>[^<]+</loc>' | \
    sed 's|<loc>||' | \
    sed 's|</loc>||' | \
    sort -u >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null

# Crawling básico con curl (solo la página principal)
echo "  🕷️  Crawling básico de la página principal..."
curl -s "https://${DOMINIO}" 2>/dev/null | \
    grep -oE 'href=["'\'']?https?://[^"'\'' ]+' | \
    sed 's/href=["'\'']\?//' | \
    sed 's/["'\'']$//' | \
    grep -E "^https?://${DOMINIO}" | \
    sort -u >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null

# Extraer URLs de robots.txt
echo "  🤖 Consultando robots.txt..."
curl -s "https://${DOMINIO}/robots.txt" 2>/dev/null | \
    grep -E "^[Ss]itemap:" | \
    sed 's/^[Ss]itemap:\s*//' | \
    sort -u >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null

# URLs de subdominios encontrados
if [ -s "$DIR_RESULTADOS/subdominios.txt" ]; then
    echo "  🔄 Buscando URLs en subdominios encontrados..."
    while IFS= read -r sub; do
        curl -s "http://web.archive.org/cdx/search/cdx?url=${sub}/*&output=text&fl=original&collapse=urlkey&limit=100" 2>/dev/null | \
            head -50 | \
            sort -u >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    done < <(head -10 "$DIR_RESULTADOS/subdominios.txt")
fi

# Procesar URLs
sort -u "$DIR_RESULTADOS/urls_temp.txt" > "$DIR_RESULTADOS/todas_urls.txt"
URLS_COUNT=$(wc -l < "$DIR_RESULTADOS/todas_urls.txt" 2>/dev/null || echo 0)
echo "  ✅ Encontradas: $URLS_COUNT URLs"

# ============================================
# 3. Filtrar y organizar resultados
# ============================================
echo ""
echo "📊 Organizando resultados..."

# URLs con parámetros
grep "?" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/urls_con_parametros.txt" 2>/dev/null

# Archivos por extensión
grep -E "\.(pdf|doc|docx|xls|xlsx|zip|rar|tar|gz)$" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/archivos.txt" 2>/dev/null

# Directorios comunes
grep -E "(admin|login|api|dashboard|panel|config|test|dev)" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/directorios_interesantes.txt" 2>/dev/null

# ============================================
# 4. Reporte final
# ============================================
echo ""
echo "✅ BÚSQUEDA COMPLETADA"
echo "=================================================="
echo "📁 Resultados guardados en: $DIR_RESULTADOS/"
echo ""
echo "📊 ESTADÍSTICAS:"
echo "   🌐 Subdominios: $SUBS_COUNT"
echo "   🔗 URLs totales: $URLS_COUNT"
echo "   📝 URLs con parámetros: $(wc -l < "$DIR_RESULTADOS/urls_con_parametros.txt" 2>/dev/null || echo 0)"
echo "   📄 Archivos encontrados: $(wc -l < "$DIR_RESULTADOS/archivos.txt" 2>/dev/null || echo 0)"
echo ""

# Mostrar algunos ejemplos
if [ -s "$DIR_RESULTADOS/subdominios.txt" ]; then
    echo "📍 Ejemplos de subdominios:"
    head -5 "$DIR_RESULTADOS/subdominios.txt" | sed 's/^/   • /'
    echo ""
fi

if [ -s "$DIR_RESULTADOS/todas_urls.txt" ]; then
    echo "📍 Ejemplos de URLs:"
    head -5 "$DIR_RESULTADOS/todas_urls.txt" | sed 's/^/   • /'
    echo ""
fi

echo "📋 Archivos generados:"
echo "   • subdominios.txt"
echo "   • todas_urls.txt"
echo "   • urls_con_parametros.txt"
echo "   • archivos.txt"
echo "   • directorios_interesantes.txt"

# Limpiar temporales
rm -f "$DIR_RESULTADOS"/*temp* 2>/dev/null

echo ""
echo "💡 Tip: Este script es liviano pero limitado. Para mejores resultados, usa busqueda_intermedia.sh o busqueda_completa.sh"

