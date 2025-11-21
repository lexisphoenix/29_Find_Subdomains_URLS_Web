#!/bin/bash
DOMINIO="schriftlabor.at"
RUTA_ESPECIFICA="ILT/python"

echo "🔍 Búsqueda avanzada en $DOMINIO..."
echo "🎯 Buscando: /$RUTA_ESPECIFICA/"

# 1. Verificar si la URL específica existe
echo "🔎 Verificando URL específica..."
URL_ESPECIFICA="https://schriftlabor.at/ILT/python/video1728816638.mp4"
status_code=$(curl -s -o /dev/null -w "%{http_code}" "$URL_ESPECIFICA")

if [ "$status_code" -eq 200 ]; then
    echo "✅ La URL EXISTE (Status: $status_code) pero no está indexada"
    echo "$URL_ESPECIFICA" > url_especifica.txt
else
    echo "❌ La URL NO EXISTE (Status: $status_code)"
fi

# 2. Crawling agresivo con Katana
echo "🕷️ Crawling profundo..."
katana -u "https://$DOMINIO" -silent -f -depth 4 -jc -kf all > katana_urls.txt

# 3. Búsqueda con gau incluyendo subdominios
echo "🌐 Búsqueda en archivos..."
gau --subs "$DOMINIO" > gau_urls.txt

# 4. Búsqueda específica por patrones
echo "🎯 Buscando archivos en /$RUTA_ESPECIFICA/..."
gau "$DOMINIO" | grep -E "$RUTA_ESPECIFICA.*\.(mp4|mp3|pdf|zip|txt)$" > rutas_especificas.txt

# 5. Combinar resultados
cat katana_urls.txt gau_urls.txt rutas_especificas.txt url_especifica.txt 2>/dev/null | sort 
-u > "${DOMINIO}_avanzado.txt"

# Resultados
echo ""
echo "📊 RESULTADOS AVANZADOS:"
echo "=================================="
echo "🔗 URLs totales encontradas: $(cat ${DOMINIO}_avanzado.txt 2>/dev/null | wc -l)"
echo "📁 URLs en /$RUTA_ESPECIFICA/: $(grep -c "$RUTA_ESPECIFICA" ${DOMINIO}_avanzado.txt 
2>/dev/null)"
echo "🎥 Archivos de video: $(grep -c "\.mp4" ${DOMINIO}_avanzado.txt 2>/dev/null)"

# Mostrar URLs de la ruta específica
echo ""
echo "📍 Contenido de /$RUTA_ESPECIFICA/:"
grep "$RUTA_ESPECIFICA" "${DOMINIO}_avanzado.txt" 2>/dev/null | head -20

# Buscar patrones de video
echo ""
echo "🎥 Posibles videos encontrados:"
grep -E "video[0-9]+\.mp4" "${DOMINIO}_avanzado.txt" 2>/dev/null | head -10

echo ""
echo "💾 Resultados guardados en: ${DOMINIO}_avanzado.txt"
