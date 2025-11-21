#!/bin/bash

# ============================================
# SCRIPT COMPLETO - Todas las herramientas disponibles
# Máxima cobertura de subdominios y URLs
# ============================================

DOMINIO="${1:-example.com}"

if [ -z "$DOMINIO" ]; then
    echo "❌ Uso: $0 <dominio>"
    echo "   Ejemplo: $0 example.com"
    exit 1
fi

# Limpiar dominio
DOMINIO=$(echo "$DOMINIO" | sed 's|^https\?://||' | sed 's|/$||' | sed 's|/.*||')
DOMINIO_LIMPIO=$(echo "$DOMINIO" | sed 's/[^a-zA-Z0-9._-]/_/g')

# Agregar directorios comunes al PATH
export PATH="$PATH:$HOME/go/bin:$HOME/.local/bin:/usr/local/bin"

echo "🚀 Búsqueda COMPLETA de URLs y subdominios para: $DOMINIO"
echo "=================================================="
echo "🔧 Usando TODAS las herramientas disponibles"
echo ""

# Crear directorio de resultados
FECHA=$(date +%Y%m%d_%H%M%S)
DIR_RESULTADOS="resultados_${DOMINIO_LIMPIO}_${FECHA}"
mkdir -p "$DIR_RESULTADOS"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Verificar herramientas
echo "🔍 Verificando herramientas instaladas..."
declare -A HERRAMIENTAS=(
    ["subfinder"]="Enumeración de subdominios"
    ["assetfinder"]="Búsqueda de assets"
    ["amass"]="Enumeración avanzada de subdominios"
    ["findomain"]="Búsqueda rápida de subdominios"
    ["chaos"]="ProjectDiscovery Chaos"
    ["waybackurls"]="URLs históricas de Wayback Machine"
    ["gau"]="Get All URLs"
    ["katana"]="Crawler avanzado"
    ["hakrawler"]="Crawler web"
    ["gospider"]="Crawler rápido"
    ["httpx"]="Verificación HTTP"
    ["dnsx"]="Consulta DNS masiva"
    ["anew"]="Agregar líneas únicas"
)

HERRAMIENTAS_DISPONIBLES=()
HERRAMIENTAS_FALTANTES=()

for tool in "${!HERRAMIENTAS[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo -e "${GREEN}✅${NC} $tool - ${HERRAMIENTAS[$tool]}"
        HERRAMIENTAS_DISPONIBLES+=("$tool")
    else
        echo -e "${YELLOW}⚠️${NC} $tool - No instalado"
        HERRAMIENTAS_FALTANTES+=("$tool")
    fi
done

echo ""

# ============================================
# 1. ENUMERACIÓN DE SUBDOMINIOS
# ============================================
echo "🌐 FASE 1: Enumeración de subdominios..."
echo "----------------------------------------"

> "$DIR_RESULTADOS/subs_temp.txt"

# Subfinder
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " subfinder " ]]; then
    echo "  🔍 Ejecutando subfinder..."
    subfinder -d "$DOMINIO" -silent -o "$DIR_RESULTADOS/subs_subfinder.txt" 2>/dev/null
    cat "$DIR_RESULTADOS/subs_subfinder.txt" >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null
fi

# Assetfinder
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " assetfinder " ]]; then
    echo "  🔍 Ejecutando assetfinder..."
    assetfinder --subs-only "$DOMINIO" >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null
fi

# Amass
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " amass " ]]; then
    echo "  🔍 Ejecutando amass..."
    amass enum -passive -d "$DOMINIO" -o "$DIR_RESULTADOS/subs_amass.txt" 2>/dev/null
    cat "$DIR_RESULTADOS/subs_amass.txt" >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null
fi

# Findomain
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " findomain " ]]; then
    echo "  🔍 Ejecutando findomain..."
    findomain -t "$DOMINIO" -q -o "$DIR_RESULTADOS/subs_findomain.txt" 2>/dev/null
    cat "$DIR_RESULTADOS/subs_findomain.txt" >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null
fi

# Chaos (ProjectDiscovery)
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " chaos " ]]; then
    echo "  🔍 Ejecutando chaos..."
    chaos -d "$DOMINIO" -silent >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null
fi

# DNSx para verificar subdominios
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " dnsx " ]]; then
    echo "  🔍 Verificando subdominios con dnsx..."
    if [ -s "$DIR_RESULTADOS/subs_temp.txt" ]; then
        cat "$DIR_RESULTADOS/subs_temp.txt" | dnsx -silent -a -resp >> "$DIR_RESULTADOS/subs_verificados.txt" 2>/dev/null
    fi
fi

# Procesar subdominios
sort -u "$DIR_RESULTADOS/subs_temp.txt" > "$DIR_RESULTADOS/subdominios.txt"
SUBS_COUNT=$(wc -l < "$DIR_RESULTADOS/subdominios.txt" 2>/dev/null || echo 0)
echo "  ✅ Total subdominios encontrados: $SUBS_COUNT"

# Verificar subdominios activos con httpx
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " httpx " ]] && [ -s "$DIR_RESULTADOS/subdominios.txt" ]; then
    echo "  🔍 Verificando subdominios activos con httpx..."
    cat "$DIR_RESULTADOS/subdominios.txt" | httpx -silent -status-code -title -tech-detect -o "$DIR_RESULTADOS/subdominios_activos.txt" 2>/dev/null
    SUBS_ACTIVOS=$(wc -l < "$DIR_RESULTADOS/subdominios_activos.txt" 2>/dev/null || echo 0)
    echo "  ✅ Subdominios activos: $SUBS_ACTIVOS"
fi

# ============================================
# 2. ENUMERACIÓN DE URLs
# ============================================
echo ""
echo "🔗 FASE 2: Enumeración de URLs..."
echo "----------------------------------------"

> "$DIR_RESULTADOS/urls_temp.txt"

# Waybackurls
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " waybackurls " ]]; then
    echo "  📚 Ejecutando waybackurls..."
    waybackurls "$DOMINIO" >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    
    # También para subdominios
    if [ -s "$DIR_RESULTADOS/subdominios.txt" ]; then
        cat "$DIR_RESULTADOS/subdominios.txt" | waybackurls >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    fi
fi

# Gau
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " gau " ]]; then
    echo "  📚 Ejecutando gau..."
    gau "$DOMINIO" --subs >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
fi

# Katana (crawling profundo)
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " katana " ]]; then
    echo "  🕷️  Ejecutando katana (crawling profundo)..."
    katana -u "https://$DOMINIO" -silent -jc -aff -depth 5 -f qurl >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    
    # Crawling en subdominios activos
    if [ -f "$DIR_RESULTADOS/subdominios_activos.txt" ] && [ -s "$DIR_RESULTADOS/subdominios_activos.txt" ]; then
        cat "$DIR_RESULTADOS/subdominios_activos.txt" | grep -oE 'https?://[^ ]+' | katana -silent -jc -aff -depth 3 >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    fi
fi

# Hakrawler
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " hakrawler " ]]; then
    echo "  🕷️  Ejecutando hakrawler..."
    echo "https://$DOMINIO" | hakrawler -subs -depth 3 >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
fi

# GoSpider
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " gospider " ]]; then
    echo "  🕷️  Ejecutando gospider..."
    gospider -s "https://$DOMINIO" -d 3 -q --other-source --sitemap --robots -o "$DIR_RESULTADOS/gospider_output" 2>/dev/null
    cat "$DIR_RESULTADOS/gospider_output"/* 2>/dev/null | grep -oE 'https?://[^ ]+' >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
fi

# Procesar URLs
if command -v anew >/dev/null 2>&1; then
    sort -u "$DIR_RESULTADOS/urls_temp.txt" | anew "$DIR_RESULTADOS/todas_urls.txt" > /dev/null 2>&1
else
    sort -u "$DIR_RESULTADOS/urls_temp.txt" > "$DIR_RESULTADOS/todas_urls.txt"
fi

URLS_COUNT=$(wc -l < "$DIR_RESULTADOS/todas_urls.txt" 2>/dev/null || echo 0)
echo "  ✅ Total URLs encontradas: $URLS_COUNT"

# ============================================
# 3. FILTRADO Y ORGANIZACIÓN
# ============================================
echo ""
echo "📊 FASE 3: Filtrando y organizando resultados..."
echo "----------------------------------------"

# URLs con parámetros
grep "?" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/urls_con_parametros.txt" 2>/dev/null

# Archivos por tipo
grep -E "\.(pdf|doc|docx|xls|xlsx|zip|rar|tar|gz|sql|bak|old|backup)$" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/archivos_sensibles.txt" 2>/dev/null

# Directorios sensibles
grep -iE "(admin|login|dashboard|panel|config|api|upload|test|debug|backup|private|secret)" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/directorios_sensibles.txt" 2>/dev/null

# JavaScript files
grep -E "\.js$" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/javascript_files.txt" 2>/dev/null

# API endpoints
grep -iE "/api/|/v[0-9]+/|/rest/|/graphql" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/api_endpoints.txt" 2>/dev/null

# ============================================
# 4. VERIFICACIÓN DE URLs ACTIVAS
# ============================================
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " httpx " ]] && [ -s "$DIR_RESULTADOS/todas_urls.txt" ]; then
    echo "  🔍 Verificando URLs activas con httpx..."
    cat "$DIR_RESULTADOS/todas_urls.txt" | httpx -silent -status-code -title -tech-detect -o "$DIR_RESULTADOS/urls_activas.txt" 2>/dev/null
    URLS_ACTIVAS=$(wc -l < "$DIR_RESULTADOS/urls_activas.txt" 2>/dev/null || echo 0)
    echo "  ✅ URLs activas: $URLS_ACTIVAS"
fi

# ============================================
# 5. REPORTE FINAL
# ============================================
echo ""
echo "✅ BÚSQUEDA COMPLETA FINALIZADA"
echo "=================================================="
echo "📁 Resultados guardados en: $DIR_RESULTADOS/"
echo ""

cat > "$DIR_RESULTADOS/reporte.txt" << EOF
📊 REPORTE COMPLETO - $DOMINIO
Fecha: $(date)
==========================================

ESTADÍSTICAS:
-------------
Subdominios encontrados: $SUBS_COUNT
Subdominios activos: $(wc -l < "$DIR_RESULTADOS/subdominios_activos.txt" 2>/dev/null || echo 0)
URLs totales: $URLS_COUNT
URLs activas: $(wc -l < "$DIR_RESULTADOS/urls_activas.txt" 2>/dev/null || echo 0)
URLs con parámetros: $(wc -l < "$DIR_RESULTADOS/urls_con_parametros.txt" 2>/dev/null || echo 0)
Archivos sensibles: $(wc -l < "$DIR_RESULTADOS/archivos_sensibles.txt" 2>/dev/null || echo 0)
Endpoints API: $(wc -l < "$DIR_RESULTADOS/api_endpoints.txt" 2>/dev/null || echo 0)

HERRAMIENTAS UTILIZADAS:
-----------------------
$(for tool in "${HERRAMIENTAS_DISPONIBLES[@]}"; do echo "  ✅ $tool"; done)

HERRAMIENTAS NO DISPONIBLES:
---------------------------
$(for tool in "${HERRAMIENTAS_FALTANTES[@]}"; do echo "  ⚠️  $tool"; done)

ARCHIVOS GENERADOS:
------------------
$(ls -lh "$DIR_RESULTADOS"/*.txt 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}')
EOF

echo "📊 ESTADÍSTICAS FINALES:"
echo "   🌐 Subdominios: $SUBS_COUNT"
echo "   🔗 URLs totales: $URLS_COUNT"
echo "   📝 URLs con parámetros: $(wc -l < "$DIR_RESULTADOS/urls_con_parametros.txt" 2>/dev/null || echo 0)"
echo "   📄 Archivos sensibles: $(wc -l < "$DIR_RESULTADOS/archivos_sensibles.txt" 2>/dev/null || echo 0)"
echo "   🔌 Endpoints API: $(wc -l < "$DIR_RESULTADOS/api_endpoints.txt" 2>/dev/null || echo 0)"
echo ""

# Mostrar algunos ejemplos
if [ -s "$DIR_RESULTADOS/subdominios.txt" ]; then
    echo "📍 Top 10 subdominios:"
    head -10 "$DIR_RESULTADOS/subdominios.txt" | sed 's/^/   • /'
    echo ""
fi

if [ -s "$DIR_RESULTADOS/urls_con_parametros.txt" ]; then
    echo "📍 Ejemplos de URLs con parámetros:"
    head -5 "$DIR_RESULTADOS/urls_con_parametros.txt" | sed 's/^/   • /'
    echo ""
fi

echo "📋 Archivos generados en: $DIR_RESULTADOS/"
echo "📄 Reporte completo: $DIR_RESULTADOS/reporte.txt"

# Limpiar temporales
rm -f "$DIR_RESULTADOS"/*temp* "$DIR_RESULTADOS"/gospider_output 2>/dev/null

if [ ${#HERRAMIENTAS_FALTANTES[@]} -gt 0 ]; then
    echo ""
    echo -e "${YELLOW}💡 Tip: Instala las herramientas faltantes para mejores resultados:${NC}"
    for tool in "${HERRAMIENTAS_FALTANTES[@]}"; do
        echo "   • $tool"
    done
fi

