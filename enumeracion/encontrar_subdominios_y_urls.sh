#!/bin/bash
DOMINIO="graphicthinking.com"

echo "🎯 Escaneo completo de $DOMINIO..."

# Subdominios
echo "🔍 Buscando subdominios..."
subfinder -d $DOMINIO -silent > subs.txt
assetfinder --subs-only $DOMINIO >> subs.txt

# URLs
echo "🔗 Buscando URLs..."
waybackurls $DOMINIO > urls.txt
gau $DOMINIO >> urls.txt
katana -u "https://$DOMINIO" -silent >> urls.txt

# Resultados finales
sort -u subs.txt > "${DOMINIO}_subdominios.txt"
sort -u urls.txt > "${DOMINIO}_urls.txt"

echo ""
echo "📊 RESULTADOS FINALES:"
echo "=================================="
echo "🌐 Subdominios: $(cat ${DOMINIO}_subdominios.txt | wc -l)"
echo "🔗 URLs: $(cat ${DOMINIO}_urls.txt | wc -l)"
echo ""
echo "📍 Tus páginas deberían aparecer en las URLs, no en subdominios"

# Limpiar
rm subs.txt urls.txt
