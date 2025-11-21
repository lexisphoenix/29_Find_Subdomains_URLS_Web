# 🔍 Scripts de Enumeración

Esta carpeta contiene scripts específicos para enumeración de subdominios y URLs. Scripts más simples y enfocados en tareas específicas.

---

## 📋 Scripts Disponibles

### 1. `encontrar_subdominios_basico.sh` 🌐

**Enumeración básica de subdominios**

**Descripción:**
Script simple y rápido para encontrar subdominios usando subfinder y assetfinder. Ideal para enumeración rápida sin complejidad.

**Cuándo usarlo:**
- Enumeración rápida de subdominios
- Cuando solo necesitas subdominios básicos
- Para pruebas rápidas

**Dependencias:**
- `subfinder` - Enumeración de subdominios
- `assetfinder` - Búsqueda de assets (opcional)

**Uso:**
```bash
# 1. Editar el script para cambiar:
DOMINIO="example.com"

# 2. Ejecutar
./encontrar_subdominios_basico.sh
```

**Estructura del Script:**
```
1. Verificación de herramientas
2. Enumeración con subfinder
3. Enumeración con assetfinder (si disponible)
4. Deduplicación y ordenamiento
5. Reporte de resultados
```

**Archivos generados:**
- `{DOMINIO}_subdominios.txt` - Lista de subdominios encontrados

**Ejemplo de salida:**
```
🌐 Subdominios encontrados: 25
```

---

### 2. `encontrar_subdominios_completo.sh` 🌐✨

**Enumeración completa de subdominios y URLs con organización**

**Descripción:**
Script completo que encuentra tanto subdominios como URLs, con mejor organización y filtrado. Incluye búsqueda de páginas específicas.

**Cuándo usarlo:**
- Enumeración completa de subdominios y URLs
- Cuando necesitas resultados organizados
- Para auditorías básicas

**Dependencias:**
- `subfinder` - Enumeración de subdominios
- `assetfinder` - Búsqueda de assets
- `waybackurls` - URLs históricas
- `gau` - Get All URLs
- `katana` - Crawler

**Uso:**
```bash
# 1. Editar el script para cambiar:
URL_INPUT="https://example.com/"

# 2. Ejecutar
./encontrar_subdominios_completo.sh
```

**Estructura del Script:**
```
1. Configuración y limpieza de dominio
2. Verificación de herramientas
3. Enumeración de subdominios (subfinder, assetfinder)
4. Enumeración de URLs (waybackurls, gau, katana)
5. Procesamiento y deduplicación
6. Filtrado de URLs (excluye CSS, JS, imágenes)
7. Búsqueda de páginas específicas (contacto, portfolio, blog, etc.)
8. Reporte con estadísticas y ejemplos
```

**Archivos generados:**
- `{DOMINIO}_subdominios.txt` - Subdominios encontrados
- `{DOMINIO}_urls.txt` - URLs encontradas

**Páginas específicas buscadas:**
- contacto, portfolio, blog, about, shop, services

---

### 3. `encontrar_subdominios_y_urls.sh` 🔗

**Enumeración simple de subdominios y URLs**

**Descripción:**
Script simple que encuentra tanto subdominios como URLs usando herramientas básicas. Sin filtrado avanzado, solo resultados directos.

**Cuándo usarlo:**
- Enumeración básica de subdominios y URLs
- Cuando necesitas ambos resultados
- Para pruebas rápidas

**Dependencias:**
- `subfinder` - Enumeración de subdominios
- `assetfinder` - Búsqueda de assets
- `waybackurls` - URLs históricas
- `gau` - Get All URLs
- `katana` - Crawler

**Uso:**
```bash
# 1. Editar el script para cambiar:
DOMINIO="example.com"

# 2. Ejecutar
./encontrar_subdominios_y_urls.sh
```

**Estructura del Script:**
```
1. Enumeración de subdominios (subfinder, assetfinder)
2. Enumeración de URLs (waybackurls, gau, katana)
3. Procesamiento y deduplicación
4. Reporte básico
```

**Archivos generados:**
- `{DOMINIO}_subdominios.txt` - Subdominios encontrados
- `{DOMINIO}_urls.txt` - URLs encontradas

---

### 4. `encontrar_urls_basico.sh` 🔗

**Enumeración básica de URLs (sin subdominios)**

**Descripción:**
Script básico para encontrar URLs usando waybackurls, gau y katana. Solo URLs, no subdominios.

**Cuándo usarlo:**
- Cuando solo necesitas URLs (no subdominios)
- Para búsqueda rápida de URLs
- Para pruebas básicas

**Dependencias:**
- `waybackurls` - URLs históricas
- `gau` - Get All URLs
- `katana` - Crawler

**Uso:**
```bash
# 1. Editar el script para cambiar:
DOMINIO="example.com"

# 2. Ejecutar
./encontrar_urls_basico.sh
```

**Estructura del Script:**
```
1. Enumeración de URLs (waybackurls, gau, katana)
2. Procesamiento y deduplicación
3. Reporte con ejemplos
```

**Archivos generados:**
- `{DOMINIO}_todas_urls.txt` - Todas las URLs encontradas

---

## 📊 Comparación de Scripts

| Script | Subdominios | URLs | Filtrado | Organización |
|--------|------------|------|----------|--------------|
| `encontrar_subdominios_basico.sh` | ✅ | ❌ | ❌ | Básica |
| `encontrar_subdominios_completo.sh` | ✅ | ✅ | ✅ | Avanzada |
| `encontrar_subdominios_y_urls.sh` | ✅ | ✅ | ❌ | Básica |
| `encontrar_urls_basico.sh` | ❌ | ✅ | ❌ | Básica |

---

## 🎯 ¿Cuál Usar?

- **Solo subdominios rápidos:** `encontrar_subdominios_basico.sh`
- **Subdominios y URLs organizados:** `encontrar_subdominios_completo.sh`
- **Subdominios y URLs simples:** `encontrar_subdominios_y_urls.sh`
- **Solo URLs:** `encontrar_urls_basico.sh`

---

## 📦 Instalación de Dependencias

```bash
# Configurar PATH
export PATH=$PATH:$(go env GOPATH)/bin

# Herramientas básicas
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
```

---

## 🔧 Configuración

Todos los scripts requieren edición manual:

1. **Abrir el script** en un editor
2. **Buscar la variable** al inicio:
   - `DOMINIO="..."`
   - `URL_INPUT="..."`
3. **Modificar** con tu dominio
4. **Guardar** y ejecutar

---

## ⚠️ Notas

1. **Edición Manual:** Todos requieren editar el dominio manualmente
2. **Permisos:** Asegúrate de tener permisos: `chmod +x *.sh`
3. **Resultados:** Los resultados se guardan en archivos `.txt` en el mismo directorio
4. **Legalidad:** Solo usa en dominios que posees o tienes permiso para probar

---

**Ver el [README principal](../README.md) para documentación completa.**

