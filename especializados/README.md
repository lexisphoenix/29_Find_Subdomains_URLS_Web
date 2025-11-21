# 🎯 Scripts Especializados

Esta carpeta contiene scripts especializados para casos de uso específicos: búsqueda en rutas específicas, crawling avanzado y descubrimiento de archivos ocultos.

---

## 📋 Scripts Disponibles

### 1. `busqueda_rutas_especificas.sh` 📁

**Búsqueda de URLs en rutas específicas y archivos multimedia**

**Descripción:**
Busca URLs en una ruta específica del dominio y archivos de video/audio. Ideal cuando conoces parte de la estructura del sitio o buscas contenido multimedia.

**Cuándo usarlo:**
- Buscar contenido en una ruta específica conocida
- Encontrar archivos de video/audio
- Cuando sabes que existe contenido en `/ruta/especifica/`

**Dependencias:**
- `gau` - Get All URLs
- `waybackurls` - URLs históricas

**Uso:**
```bash
# 1. Editar el script para cambiar:
DOMINIO="example.com"
RUTA_ESPECIFICA="ruta/buscada"

# 2. Ejecutar
./busqueda_rutas_especificas.sh
```

**Estructura del Script:**
```
1. Búsqueda normal (todas las URLs)
2. Búsqueda específica por patrones (videos/audio)
3. Búsqueda en ruta específica
4. Combinación y deduplicación
5. Reporte con estadísticas
```

**Archivos generados:**
- `{DOMINIO}_completo.txt` - Todas las URLs encontradas

**Ejemplo de salida:**
```
🔗 URLs totales: 1250
🎯 URLs en /ruta/especifica/: 45
📹 Archivos de video: 12
```

---

### 2. `busqueda_avanzada_katana.sh` 🕷️

**Crawling agresivo con Katana y verificación de URLs**

**Descripción:**
Búsqueda avanzada con crawling profundo usando Katana. Incluye verificación de URLs específicas y búsqueda en rutas específicas. Ideal para encontrar URLs no indexadas.

**Cuándo usarlo:**
- Crawling profundo y agresivo
- Encontrar URLs no indexadas
- Verificar existencia de URLs específicas
- Buscar archivos en rutas específicas

**Dependencias:**
- `katana` - Crawler avanzado
- `gau` - Get All URLs
- `curl` - Verificación de URLs

**Uso:**
```bash
# 1. Editar el script para cambiar:
DOMINIO="example.com"
RUTA_ESPECIFICA="ruta/buscada"
URL_ESPECIFICA="https://example.com/ruta/archivo.mp4"

# 2. Ejecutar
./busqueda_avanzada_katana.sh
```

**Estructura del Script:**
```
1. Verificación de URL específica (curl)
2. Crawling agresivo con Katana (depth 4, JS crawling, form discovery)
3. Búsqueda con Gau (incluyendo subdominios)
4. Búsqueda específica por patrones
5. Combinación de resultados
6. Reporte avanzado
```

**Características especiales:**
- **Depth 4** - Crawling profundo
- **JavaScript crawling** - Encuentra URLs en JS
- **Form discovery** - Descubre formularios
- **Verificación de URLs** - Comprueba existencia

**Archivos generados:**
- `katana_urls.txt` - URLs encontradas por Katana
- `gau_urls.txt` - URLs encontradas por Gau
- `rutas_especificas.txt` - URLs en ruta específica
- `url_especifica.txt` - URL específica verificada
- `{DOMINIO}_avanzado.txt` - Todas las URLs combinadas

---

### 3. `busqueda_archivos_ocultos.sh` 🔍

**Fuerza bruta de archivos ocultos mediante patrones**

**Descripción:**
Busca archivos ocultos probando diferentes patrones de nombres. Prueba timestamps, nombres comunes y secuencias numéricas. Útil para descubrir contenido no indexado.

**Cuándo usarlo:**
- Encontrar archivos no indexados
- Cuando conoces patrones de nombres de archivos
- Descubrir contenido oculto
- Buscar archivos con timestamps o números secuenciales

**Dependencias:**
- `curl` - Verificación de URLs (suele estar instalado)

**Uso:**
```bash
# 1. Editar el script para cambiar:
DOMINIO="example.com"
BASE_URL="https://example.com/ruta/base"

# 2. Ejecutar
./busqueda_archivos_ocultos.sh
```

**Estructura del Script:**
```
1. Archivos conocidos (agregar manualmente)
2. Patrón 1: video[TIMESTAMP].mp4 (rango de timestamps)
3. Patrón 2: Nombres comunes (test, demo, example, etc.)
4. Patrón 3: Secuencias numéricas (1-100)
5. Verificación con curl (status code 200)
6. Reporte de archivos encontrados
```

**Patrones probados:**
- `video{timestamp}.mp4` - Para timestamps en rango específico
- `{nombre}.{ext}` - Nombres comunes con extensiones
- `video{numero}.mp4` - Secuencias numéricas

**Archivos generados:**
- `archivos_encontrados.txt` - Archivos ocultos descubiertos

**⚠️ Advertencia:**
Este script hace muchas peticiones HTTP. Considera agregar delays entre peticiones para evitar saturar el servidor.

**Ejemplo de modificación para agregar delays:**
```bash
# Agregar después de cada curl:
sleep 0.5  # Esperar 0.5 segundos entre peticiones
```

---

## 🔧 Configuración Común

Todos los scripts especializados requieren edición manual antes de ejecutar:

1. **Abrir el script** en un editor
2. **Buscar las variables** al inicio:
   - `DOMINIO="..."`
   - `RUTA_ESPECIFICA="..."`
   - `BASE_URL="..."`
   - `URL_ESPECIFICA="..."`
3. **Modificar** con tus valores
4. **Guardar** y ejecutar

---

## 📊 Comparación de Scripts Especializados

| Script | Propósito | Dependencias | Complejidad |
|--------|-----------|-------------|-------------|
| `busqueda_rutas_especificas.sh` | Rutas y multimedia | 2 | ⭐⭐ |
| `busqueda_avanzada_katana.sh` | Crawling profundo | 3 | ⭐⭐⭐ |
| `busqueda_archivos_ocultos.sh` | Archivos ocultos | 1 | ⭐ |

---

## 💡 Casos de Uso

### Caso 1: Buscar videos en una carpeta específica
```bash
# Usar: busqueda_rutas_especificas.sh
DOMINIO="example.com"
RUTA_ESPECIFICA="videos/"
```

### Caso 2: Encontrar URLs no indexadas
```bash
# Usar: busqueda_avanzada_katana.sh
# Katana hace crawling profundo que encuentra URLs no indexadas
```

### Caso 3: Descubrir archivos con patrón conocido
```bash
# Usar: busqueda_archivos_ocultos.sh
# Modificar patrones según lo que buscas
```

---

## ⚠️ Notas Importantes

1. **Edición Manual:** Todos estos scripts requieren edición manual antes de usar
2. **Rate Limits:** Respeta los rate limits, especialmente en `busqueda_archivos_ocultos.sh`
3. **Legalidad:** Solo usa en dominios que posees o tienes permiso para probar
4. **Permisos:** Asegúrate de tener permisos de ejecución: `chmod +x *.sh`

---

**Ver el [README principal](../README.md) para documentación completa.**

