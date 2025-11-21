#!/bin/bash
DOMINIO="lexisphoenix.com"

echo "🔍 Buscando TODAS las URLs de $DOMINIO..."

# Usar múltiples herramientas
echo "📚 Usando Wayback Machine..."
waybackurls $DOMINIO > urls_temp1.txt

echo "🌐 Usando Gau..."
gau $DOMINIO > urls_temp2.txt

echo "🕷️ Haciendo crawling con Katana..."
katana -u "https://$DOMINIO" -silent > urls_temp3.txt

# Combinar todos los resultados
cat urls_temp1.txt urls_temp2.txt urls_temp3.txt | sort -u > "${DOMINIO}_todas_urls.txt"

# Estadísticas
echo ""
echo "📊 RESULTADOS:"
echo "================================"
echo "🔗 URLs encontradas: $(cat ${DOMINIO}_todas_urls.txt | wc -l)"
echo ""
echo "🌐 Algunas URLs encontradas:"
cat "${DOMINIO}_todas_urls.txt" | head -20

# Limpiar
rm urls_temp1.txt urls_temp2.txt urls_temp3.txt
