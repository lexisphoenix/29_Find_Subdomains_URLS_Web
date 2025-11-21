# 🚀 Scripts Principales

Esta carpeta contiene los 3 scripts principales para búsqueda de subdominios y URLs, ordenados de más liviano a más completo.

---

## 📋 Scripts Disponibles

### 1. `busqueda_liviana.sh` ⚡

**Ultra-liviano - Sin dependencias externas**

- ✅ **Sin instalaciones requeridas** - Solo usa herramientas del sistema
- ✅ **Rápido** - Resultados inmediatos
- ✅ **Ideal para:** Pruebas rápidas, sistemas con restricciones

**Dependencias:** Ninguna (solo `curl`, `grep`, `sed`, `awk`)

**Uso:**
```bash
./busqueda_liviana.sh example.com
```

**Resultados:**
- Subdominios encontrados vía APIs públicas
- URLs básicas de Wayback Machine y sitemaps
- Archivos organizados por tipo

---

### 2. `busqueda_intermedia.sh` ⚖️

**Balanceado - Herramientas esenciales**

- ✅ **4 herramientas esenciales** - Fácil de instalar
- ✅ **Resultados profesionales** - Buena cobertura
- ✅ **Ideal para:** Uso regular, auditorías básicas

**Dependencias requeridas:**
- `subfinder` - Enumeración de subdominios
- `waybackurls` - URLs históricas
- `gau` - Get All URLs
- `katana` - Crawler avanzado

**Dependencias opcionales:**
- `assetfinder` - Mejora enumeración
- `httpx` - Verificación de URLs activas

**Uso:**
```bash
./busqueda_intermedia.sh example.com
```

**Resultados:**
- Subdominios completos
- URLs históricas y activas
- Filtrado por tipo (parámetros, archivos, APIs, etc.)
- Verificación de URLs activas

---

### 3. `busqueda_completa.sh` 🔥

**Completo - Todas las herramientas disponibles**

- ✅ **Máxima cobertura** - Usa todas las herramientas instaladas
- ✅ **Detección automática** - Encuentra herramientas disponibles
- ✅ **Ideal para:** Auditorías exhaustivas, reportes profesionales

**Dependencias (usa las que encuentre):**
- `subfinder`, `assetfinder`, `amass`, `findomain`, `chaos`
- `waybackurls`, `gau`, `katana`, `hakrawler`, `gospider`
- `httpx`, `dnsx`, `anew`

**Uso:**
```bash
./busqueda_completa.sh example.com
```

**Resultados:**
- Subdominios de múltiples fuentes
- URLs de múltiples métodos
- Verificación masiva de URLs
- Organización avanzada por tipo

---

## 📊 Comparación Rápida

| Script | Dependencias | Complejidad | Cobertura | Tiempo |
|--------|-------------|-------------|-----------|--------|
| `busqueda_liviana.sh` | 0 | ⭐ | Básica | ⚡ Rápido |
| `busqueda_intermedia.sh` | 4 | ⭐⭐ | Buena | ⏱️ Medio |
| `busqueda_completa.sh` | 10+ | ⭐⭐⭐ | Máxima | 🐌 Lento |

---

## 🎯 ¿Cuál Usar?

- **Primera vez / Pruebas rápidas:** `busqueda_liviana.sh`
- **Uso regular / Auditorías:** `busqueda_intermedia.sh`
- **Máxima cobertura:** `busqueda_completa.sh`

---

## 📦 Instalación Rápida (para intermedia y completa)

```bash
# Instalar Go si no lo tienes
# macOS: brew install go
# Linux: sudo apt install golang-go

# Configurar PATH
export PATH=$PATH:$(go env GOPATH)/bin

# Herramientas esenciales (para intermedia)
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest

# Herramientas adicionales (para completa)
go install github.com/tomnomnom/assetfinder@latest
go install -v github.com/owasp-amass/amass/v4/...@master
go install -v github.com/projectdiscovery/chaos-client/cmd/chaos@latest
go install github.com/hakluke/hakrawler@latest
go install github.com/jaeles-project/gospider@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
go install -v github.com/tomnomnom/anew@latest
```

---

## 📁 Estructura de Resultados

Todos los scripts generan resultados en carpetas con el formato:
- `resultados_{dominio}/` - Para liviana e intermedia
- `resultados_{dominio}_{fecha}/` - Para completa

Cada carpeta contiene:
- Archivos de subdominios
- Archivos de URLs
- Archivos filtrados por tipo
- Reportes con estadísticas

---

## ⚠️ Notas

- Asegúrate de tener permisos de ejecución: `chmod +x *.sh`
- Los scripts aceptan el dominio como parámetro
- Respeta los rate limits de las APIs y servicios
- Solo usa en dominios que posees o tienes permiso para probar

---

**Ver el [README principal](../README.md) para documentación completa.**

