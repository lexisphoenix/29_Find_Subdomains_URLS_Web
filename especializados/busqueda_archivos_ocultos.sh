#!/bin/bash
DOMINIO="schriftlabor.at"
BASE_URL="https://$DOMINIO/ILT/python"

echo "🔍 Buscando archivos ocultos en $BASE_URL/"
echo "=============================================="

# Archivos encontrados
> archivos_encontrados.txt
echo "✅ URL conocida: ${BASE_URL}/video1728816638.mp4" >> archivos_encontrados.txt

# Buscar por diferentes patrones
echo "📝 Probando diferentes patrones..."

# Patrón 1: video[timestamp].mp4
echo "🎯 Patrón 1: video[TIMESTAMP].mp4"
for ts in {1728816600..1728816650}; do
    url="${BASE_URL}/video${ts}.mp4"
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    [ "$status" -eq 200 ] && echo "✅ $url" >> archivos_encontrados.txt
done

# Patrón 2: Archivos con nombres comunes
echo "🎯 Patrón 2: Nombres comunes"
for name in test demo example sample video audio file; do
    for ext in mp4 avi mov pdf txt zip; do
        url="${BASE_URL}/${name}.${ext}"
        status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
        [ "$status" -eq 200 ] && echo "✅ $url" >> archivos_encontrados.txt
    done
done

# Patrón 3: Números secuenciales
echo "🎯 Patrón 3: Secuencias numéricas"
for num in {1..100}; do
    url="${BASE_URL}/video${num}.mp4"
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    [ "$status" -eq 200 ] && echo "✅ $url" >> archivos_encontrados.txt
done

# Resultados
echo ""
echo "📊 RESULTADOS FINALES:"
echo "=================================="
total=$(cat archivos_encontrados.txt | wc -l)
echo "🎊 Archivos ocultos descubiertos: $total"
echo ""
echo "📍 Lista completa:"
cat archivos_encontrados.txt

echo ""
echo "💾 Guardado en: archivos_encontrados.txt"
