#!/bin/bash
DOMINIO="schriftlabor.at"
RUTA_ESPECIFICA="ILT/"

echo "🔍 Búsqueda profunda en $DOMINIO..."
echo "🎯 Buscando específicamente: /$RUTA_ESPECIFICA/"

# 1. Búsqueda normal
echo "📡 Búsqueda básica..."
gau $DOMINIO > urls_temp1.txt
waybackurls $DOMINIO >> urls_temp1.txt

# 2. Búsqueda específica por patrones
echo "🎯 Búsqueda específica para videos y archivos..."
gau $DOMINIO | grep -E "\.(mp4|mp3|avi|mov|wmv)$" >> urls_temp2.txt

# 3. Búsqueda en la ruta específica
echo "📁 Buscando en ruta /$RUTA_ESPECIFICA/..."
gau $DOMINIO | grep "$RUTA_ESPECIFICA" >> urls_temp3.txt
waybackurls $DOMINIO | grep "$RUTA_ESPECIFICA" >> urls_temp3.txt

# 4. Combinar resultados
cat urls_temp1.txt urls_temp2.txt urls_temp3.txt | sort -u > "${DOMINIO}_completo.txt"

# Resultados
echo ""
echo "📊 RESULTADOS:"
echo "=================================="
echo "🔗 URLs totales: $(cat ${DOMINIO}_completo.txt | wc -l)"
echo "🎯 URLs en /$RUTA_ESPECIFICA/: $(grep -c "$RUTA_ESPECIFICA" ${DOMINIO}_completo.txt)"
echo "📹 Archivos de video: $(grep -c "\.mp4" ${DOMINIO}_completo.txt)"

# Mostrar URLs específicas
echo ""
echo "📍 URLs en /$RUTA_ESPECIFICA/:"
grep "$RUTA_ESPECIFICA" "${DOMINIO}_completo.txt" | head -20

echo ""
echo "🎥 Archivos de video encontrados:"
grep "\.mp4" "${DOMINIO}_completo.txt" | head -10

# Limpiar
rm urls_temp1.txt urls_temp2.txt urls_temp3.txt

echo ""
echo "💾 Resultados guardados en: ${DOMINIO}_completo.txt"
