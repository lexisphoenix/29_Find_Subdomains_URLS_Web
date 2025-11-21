#!/bin/bash
DOMINIO="selfhelpplanner.com"

echo "🎯 Escaneo completo de $DOMINIO..."
echo "=================================="

# Verificar herramientas instaladas
command -v subfinder >/dev/null 2>&1 || echo "⚠️  subfinder no instalado"
command -v assetfinder >/dev/null 2>&1 || echo "⚠️  assetfinder no instalado"
command -v waybackurls >/dev/null 2>&1 || echo "⚠️  waybackurls no instalado"
command -v gau >/dev/null 2>&1 || echo "⚠️  gau no instalado"
command -v katana >/dev/null 2>&1 || echo "⚠️  katana no instalado"

# Subdominios
echo ""
echo "🔍 Buscando subdominios..."
subfinder -d $DOMINIO -silent 2>/dev/null | sort -u > subs_temp.txt
[ -x "$(command -v assetfinder)" ] && assetfinder --subs-only $DOMINIO 2>/dev/null >> 
subs_temp.txt

# URLs
echo "🔗 Buscando URLs..."
[ -x "$(command -v waybackurls)" ] && waybackurls $DOMINIO 2>/dev/null > urls_temp.txt
[ -x "$(command -v gau)" ] && gau $DOMINIO 2>/dev/null >> urls_temp.txt
[ -x "$(command -v katana)" ] && katana -u "https://$DOMINIO" -silent 2>/dev/null >> 
urls_temp.txt

# Procesar resultados
sort -u subs_temp.txt > "${DOMINIO}_subdominios.txt"
sort -u urls_temp.txt > "${DOMINIO}_urls.txt"

# Mostrar resultados
echo ""
echo "📊 RESULTADOS FINALES:"
echo "=================================="
echo "🌐 Subdominios encontrados: $(cat ${DOMINIO}_subdominios.txt | wc -l)"
echo "🔗 URLs encontradas: $(cat ${DOMINIO}_urls.txt | wc -l)"

# Mostrar algunos ejemplos de URLs
echo ""
echo "📍 Ejemplos de URLs encontradas:"
cat "${DOMINIO}_urls.txt" | grep -v "\.\(css\|js\|png\|jpg\|jpeg\|gif\)" | head -15

# Buscar páginas específicas
echo ""
echo "🔍 Páginas específicas encontradas:"
for pagina in contacto portfolio blog about; do
    count=$(cat "${DOMINIO}_urls.txt" | grep -c "$pagina" || true)
    echo "   📄 /$pagina/: $count URLs"
done

# Limpiar temporales
rm -f subs_temp.txt urls_temp.txt

echo ""
echo "✅ Análisis completado!"
echo "   Archivos creados:"
echo "   - ${DOMINIO}_subdominios.txt (subdominios)"
echo "   - ${DOMINIO}_urls.txt (todas las URLs)"
