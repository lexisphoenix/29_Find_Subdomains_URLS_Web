#!/bin/bash

# ============================================
# SCRIPT INTERMEDIO - Herramientas esenciales
# Balance entre cobertura y simplicidad
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

echo "⚖️  Búsqueda INTERMEDIA de URLs y subdominios para: $DOMINIO"
echo "=================================================="
echo "🔧 Usando herramientas esenciales balanceadas"
echo ""

# Crear directorio de resultados
DIR_RESULTADOS="resultados_${DOMINIO_LIMPIO}"
mkdir -p "$DIR_RESULTADOS"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Herramientas esenciales requeridas
HERRAMIENTAS_ESENCIALES=("subfinder" "waybackurls" "gau" "katana")

echo "🔍 Verificando herramientas esenciales..."
HERRAMIENTAS_DISPONIBLES=()
HERRAMIENTAS_FALTANTES=()

for tool in "${HERRAMIENTAS_ESENCIALES[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo -e "${GREEN}✅${NC} $tool"
        HERRAMIENTAS_DISPONIBLES+=("$tool")
    else
        echo -e "${RED}❌${NC} $tool - REQUERIDO"
        HERRAMIENTAS_FALTANTES+=("$tool")
    fi
done

# Verificar herramientas opcionales
HERRAMIENTAS_OPCIONALES=("assetfinder" "httpx")
echo ""
echo "🔍 Herramientas opcionales (mejoran resultados):"
for tool in "${HERRAMIENTAS_OPCIONALES[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo -e "${GREEN}✅${NC} $tool"
        HERRAMIENTAS_DISPONIBLES+=("$tool")
    else
        echo -e "${YELLOW}⚠️${NC} $tool - Opcional"
    fi
done

# Verificar si tenemos las herramientas mínimas
if [ ${#HERRAMIENTAS_FALTANTES[@]} -gt 0 ]; then
    echo ""
    echo -e "${RED}❌ ERROR: Faltan herramientas esenciales${NC}"
    echo "Instala las siguientes herramientas:"
    for tool in "${HERRAMIENTAS_FALTANTES[@]}"; do
        case $tool in
            subfinder)
                echo "   • subfinder: go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
                ;;
            waybackurls)
                echo "   • waybackurls: go install github.com/tomnomnom/waybackurls@latest"
                ;;
            gau)
                echo "   • gau: go install github.com/lc/gau/v2/cmd/gau@latest"
                ;;
            katana)
                echo "   • katana: go install github.com/projectdiscovery/katana/cmd/katana@latest"
                ;;
        esac
    done
    exit 1
fi

echo ""

# ============================================
# 1. ENUMERACIÓN DE SUBDOMINIOS
# ============================================
echo "🌐 FASE 1: Enumeración de subdominios..."
echo "----------------------------------------"

> "$DIR_RESULTADOS/subs_temp.txt"

# Subfinder (herramienta principal)
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " subfinder " ]]; then
    echo "  🔍 Ejecutando subfinder..."
    subfinder -d "$DOMINIO" -silent -o "$DIR_RESULTADOS/subs_subfinder.txt" 2>/dev/null
    cat "$DIR_RESULTADOS/subs_subfinder.txt" >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null
    SUBS_SUBFINDER=$(wc -l < "$DIR_RESULTADOS/subs_subfinder.txt" 2>/dev/null || echo 0)
    echo "     ✅ Subfinder: $SUBS_SUBFINDER subdominios"
fi

# Assetfinder (opcional, mejora resultados)
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " assetfinder " ]]; then
    echo "  🔍 Ejecutando assetfinder (opcional)..."
    assetfinder --subs-only "$DOMINIO" >> "$DIR_RESULTADOS/subs_temp.txt" 2>/dev/null
fi

# Procesar subdominios
sort -u "$DIR_RESULTADOS/subs_temp.txt" > "$DIR_RESULTADOS/subdominios.txt"
SUBS_COUNT=$(wc -l < "$DIR_RESULTADOS/subdominios.txt" 2>/dev/null || echo 0)
echo "  ✅ Total subdominios únicos: $SUBS_COUNT"

# Verificar subdominios activos con httpx (opcional)
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " httpx " ]] && [ -s "$DIR_RESULTADOS/subdominios.txt" ]; then
    echo "  🔍 Verificando subdominios activos con httpx..."
    cat "$DIR_RESULTADOS/subdominios.txt" | httpx -silent -status-code -title -o "$DIR_RESULTADOS/subdominios_activos.txt" 2>/dev/null
    SUBS_ACTIVOS=$(wc -l < "$DIR_RESULTADOS/subdominios_activos.txt" 2>/dev/null || echo 0)
    echo "     ✅ Subdominios activos: $SUBS_ACTIVOS"
fi

# ============================================
# 2. ENUMERACIÓN DE URLs
# ============================================
echo ""
echo "🔗 FASE 2: Enumeración de URLs..."
echo "----------------------------------------"

> "$DIR_RESULTADOS/urls_temp.txt"

# Waybackurls (URLs históricas)
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " waybackurls " ]]; then
    echo "  📚 Ejecutando waybackurls (URLs históricas)..."
    waybackurls "$DOMINIO" >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    URLS_WAYBACK=$(wc -l < "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null || echo 0)
    echo "     ✅ Waybackurls: $URLS_WAYBACK URLs"
    
    # También buscar en subdominios encontrados
    if [ -s "$DIR_RESULTADOS/subdominios.txt" ]; then
        echo "  📚 Buscando URLs en subdominios encontrados..."
        cat "$DIR_RESULTADOS/subdominios.txt" | waybackurls >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    fi
fi

# Gau (Get All URLs)
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " gau " ]]; then
    echo "  📚 Ejecutando gau (Get All URLs)..."
    gau "$DOMINIO" --subs >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    URLS_GAU=$(wc -l < "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null || echo 0)
    echo "     ✅ Gau: $URLS_GAU URLs totales"
fi

# Katana (crawling activo)
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " katana " ]]; then
    echo "  🕷️  Ejecutando katana (crawling activo)..."
    katana -u "https://$DOMINIO" -silent -jc -aff -depth 3 -f qurl >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    URLS_KATANA=$(wc -l < "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null || echo 0)
    echo "     ✅ Katana: $URLS_KATANA URLs totales"
    
    # Crawling en subdominios activos (si httpx está disponible)
    if [ -f "$DIR_RESULTADOS/subdominios_activos.txt" ] && [ -s "$DIR_RESULTADOS/subdominios_activos.txt" ]; then
        echo "  🕷️  Crawling en subdominios activos..."
        cat "$DIR_RESULTADOS/subdominios_activos.txt" | grep -oE 'https?://[^ ]+' | head -5 | \
            katana -silent -jc -aff -depth 2 >> "$DIR_RESULTADOS/urls_temp.txt" 2>/dev/null
    fi
fi

# Procesar URLs
sort -u "$DIR_RESULTADOS/urls_temp.txt" > "$DIR_RESULTADOS/todas_urls.txt"
URLS_COUNT=$(wc -l < "$DIR_RESULTADOS/todas_urls.txt" 2>/dev/null || echo 0)
echo "  ✅ Total URLs únicas: $URLS_COUNT"

# ============================================
# 3. FILTRADO Y ORGANIZACIÓN
# ============================================
echo ""
echo "📊 FASE 3: Filtrando y organizando resultados..."
echo "----------------------------------------"

# URLs con parámetros (interesantes para testing)
grep "?" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/urls_con_parametros.txt" 2>/dev/null
PARAMS_COUNT=$(wc -l < "$DIR_RESULTADOS/urls_con_parametros.txt" 2>/dev/null || echo 0)
echo "  📝 URLs con parámetros: $PARAMS_COUNT"

# Archivos sensibles
grep -E "\.(pdf|doc|docx|xls|xlsx|zip|rar|tar|gz|sql|bak|old|backup|config|env)$" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/archivos_sensibles.txt" 2>/dev/null
ARCHIVOS_COUNT=$(wc -l < "$DIR_RESULTADOS/archivos_sensibles.txt" 2>/dev/null || echo 0)
echo "  📄 Archivos sensibles: $ARCHIVOS_COUNT"

# Directorios sensibles
grep -iE "(admin|login|dashboard|panel|config|api|upload|test|debug|backup|private|secret|wp-admin)" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/directorios_sensibles.txt" 2>/dev/null
DIRS_COUNT=$(wc -l < "$DIR_RESULTADOS/directorios_sensibles.txt" 2>/dev/null || echo 0)
echo "  🔐 Directorios sensibles: $DIRS_COUNT"

# JavaScript files (útil para análisis)
grep -E "\.js$" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/javascript_files.txt" 2>/dev/null
JS_COUNT=$(wc -l < "$DIR_RESULTADOS/javascript_files.txt" 2>/dev/null || echo 0)
echo "  📜 Archivos JavaScript: $JS_COUNT"

# API endpoints
grep -iE "/api/|/v[0-9]+/|/rest/|/graphql|/webhook" "$DIR_RESULTADOS/todas_urls.txt" > "$DIR_RESULTADOS/api_endpoints.txt" 2>/dev/null
API_COUNT=$(wc -l < "$DIR_RESULTADOS/api_endpoints.txt" 2>/dev/null || echo 0)
echo "  🔌 Endpoints API: $API_COUNT"

# ============================================
# 4. VERIFICACIÓN DE URLs ACTIVAS (opcional)
# ============================================
if [[ " ${HERRAMIENTAS_DISPONIBLES[@]} " =~ " httpx " ]] && [ -s "$DIR_RESULTADOS/todas_urls.txt" ]; then
    echo ""
    echo "🔍 FASE 4: Verificando URLs activas..."
    echo "----------------------------------------"
    echo "  ⚠️  Esto puede tardar si hay muchas URLs..."
    # Limitar a las primeras 1000 URLs para no saturar
    head -1000 "$DIR_RESULTADOS/todas_urls.txt" | httpx -silent -status-code -title -o "$DIR_RESULTADOS/urls_activas.txt" 2>/dev/null
    URLS_ACTIVAS=$(wc -l < "$DIR_RESULTADOS/urls_activas.txt" 2>/dev/null || echo 0)
    echo "  ✅ URLs activas verificadas: $URLS_ACTIVAS"
fi

# ============================================
# 5. REPORTE FINAL
# ============================================
echo ""
echo "✅ BÚSQUEDA INTERMEDIA COMPLETADA"
echo "=================================================="
echo "📁 Resultados guardados en: $DIR_RESULTADOS/"
echo ""

cat > "$DIR_RESULTADOS/reporte.txt" << EOF
📊 REPORTE INTERMEDIO - $DOMINIO
Fecha: $(date)
==========================================

ESTADÍSTICAS:
-------------
Subdominios encontrados: $SUBS_COUNT
Subdominios activos: $(wc -l < "$DIR_RESULTADOS/subdominios_activos.txt" 2>/dev/null || echo 0)
URLs totales: $URLS_COUNT
URLs activas: $(wc -l < "$DIR_RESULTADOS/urls_activas.txt" 2>/dev/null || echo 0)
URLs con parámetros: $PARAMS_COUNT
Archivos sensibles: $ARCHIVOS_COUNT
Directorios sensibles: $DIRS_COUNT
Endpoints API: $API_COUNT
Archivos JavaScript: $JS_COUNT

HERRAMIENTAS UTILIZADAS:
-----------------------
$(for tool in "${HERRAMIENTAS_DISPONIBLES[@]}"; do echo "  ✅ $tool"; done)

ARCHIVOS GENERADOS:
------------------
$(ls -lh "$DIR_RESULTADOS"/*.txt 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}')
EOF

echo "📊 ESTADÍSTICAS FINALES:"
echo "   🌐 Subdominios: $SUBS_COUNT"
echo "   🔗 URLs totales: $URLS_COUNT"
echo "   📝 URLs con parámetros: $PARAMS_COUNT"
echo "   📄 Archivos sensibles: $ARCHIVOS_COUNT"
echo "   🔐 Directorios sensibles: $DIRS_COUNT"
echo "   🔌 Endpoints API: $API_COUNT"
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

if [ -s "$DIR_RESULTADOS/api_endpoints.txt" ]; then
    echo "📍 Ejemplos de endpoints API:"
    head -5 "$DIR_RESULTADOS/api_endpoints.txt" | sed 's/^/   • /'
    echo ""
fi

echo "📋 Archivos generados en: $DIR_RESULTADOS/"
echo "   • subdominios.txt"
echo "   • todas_urls.txt"
echo "   • urls_con_parametros.txt"
echo "   • archivos_sensibles.txt"
echo "   • directorios_sensibles.txt"
echo "   • api_endpoints.txt"
echo "   • javascript_files.txt"
if [ -f "$DIR_RESULTADOS/subdominios_activos.txt" ]; then
    echo "   • subdominios_activos.txt"
fi
if [ -f "$DIR_RESULTADOS/urls_activas.txt" ]; then
    echo "   • urls_activas.txt"
fi
echo "   • reporte.txt"
echo ""

# Limpiar temporales
rm -f "$DIR_RESULTADOS"/*temp* "$DIR_RESULTADOS"/subs_subfinder.txt 2>/dev/null

echo "💡 Este script usa las herramientas esenciales para un buen balance entre resultados y simplicidad."

