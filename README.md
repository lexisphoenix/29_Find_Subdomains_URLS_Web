# 🔍 Scripts de Búsqueda de Subdominios y URLs

Colección completa de scripts para enumeración de subdominios y URLs de dominios. Desde versiones ultra-livianas sin dependencias hasta suites completas de pentesting.

---

## 📁 Estructura del Proyecto

```
29_Find_Subdomains_URLS_Web/
│
├── principales/              # Scripts principales (liviana, intermedia, completa)
│   ├── busqueda_liviana.sh
│   ├── busqueda_intermedia.sh
│   ├── busqueda_completa.sh
│   └── README.md
│
├── especializados/           # Scripts para casos específicos
│   ├── busqueda_rutas_especificas.sh
│   ├── busqueda_avanzada_katana.sh
│   ├── busqueda_archivos_ocultos.sh
│   └── README.md
│
├── enumeracion/             # Scripts de enumeración básica
│   ├── encontrar_subdominios_basico.sh
│   ├── encontrar_subdominios_completo.sh
│   ├── encontrar_subdominios_y_urls.sh
│   ├── encontrar_urls_basico.sh
│   └── README.md
│
├── pentesting/              # Scripts de pentesting completo
│   ├── pentesting_completo.sh
│   └── README.md
│
└── README.md                # Este archivo (índice general)
```

---

## 🚀 Inicio Rápido

### Para Principiantes (Sin Instalar Nada)

```bash
cd principales
./busqueda_liviana.sh example.com
```

### Para Uso Regular

```bash
cd principales
./busqueda_intermedia.sh example.com
```

### Para Auditorías Profesionales

```bash
cd principales
./busqueda_completa.sh example.com
```

---

## 📚 Documentación por Categoría

### 🚀 [Scripts Principales](./principales/README.md)

Los 3 scripts principales ordenados de más liviano a más completo:

- **`busqueda_liviana.sh`** ⚡ - Sin dependencias, solo herramientas del sistema
- **`busqueda_intermedia.sh`** ⚖️ - Balance perfecto (4 herramientas esenciales)
- **`busqueda_completa.sh`** 🔥 - Máxima cobertura (todas las herramientas)

👉 **[Ver documentación completa](./principales/README.md)**

---

### 🎯 [Scripts Especializados](./especializados/README.md)

Scripts para casos de uso específicos:

- **`busqueda_rutas_especificas.sh`** 📁 - Busca URLs en rutas específicas y archivos multimedia
- **`busqueda_avanzada_katana.sh`** 🕷️ - Crawling agresivo con Katana
- **`busqueda_archivos_ocultos.sh`** 🔍 - Fuerza bruta de archivos ocultos

👉 **[Ver documentación completa](./especializados/README.md)**

---

### 🔍 [Scripts de Enumeración](./enumeracion/README.md)

Scripts específicos para enumeración de subdominios y URLs:

- **`encontrar_subdominios_basico.sh`** 🌐 - Enumeración básica de subdominios
- **`encontrar_subdominios_completo.sh`** 🌐✨ - Enumeración completa con organización
- **`encontrar_subdominios_y_urls.sh`** 🔗 - Subdominios y URLs simples
- **`encontrar_urls_basico.sh`** 🔗 - Solo URLs básicas

👉 **[Ver documentación completa](./enumeracion/README.md)**

---

### 🛡️ [Scripts de Pentesting](./pentesting/README.md)

Suite completa de pentesting:

- **`pentesting_completo.sh`** 🔥 - Análisis completo de seguridad
  - Enumeración de subdominios y URLs
  - Escaneo de vulnerabilidades (Nuclei)
  - Escaneo de puertos (Naabu)
  - Fuzzing (FFuf)
  - Análisis de headers
  - Reportes detallados

👉 **[Ver documentación completa](./pentesting/README.md)**

---

## 📊 Comparación General

| Categoría | Scripts | Dependencias | Complejidad | Uso Recomendado |
|-----------|---------|-------------|-------------|-----------------|
| **Principales** | 3 | 0-10+ | ⭐-⭐⭐⭐ | Uso general |
| **Especializados** | 3 | 1-3 | ⭐-⭐⭐⭐ | Casos específicos |
| **Enumeración** | 4 | 2-5 | ⭐-⭐⭐ | Enumeración básica |
| **Pentesting** | 1 | 10+ | ⭐⭐⭐⭐ | Auditorías completas |

---

## 🎯 ¿Qué Script Usar?

### Por Necesidad

- **Sin instalar nada:** `principales/busqueda_liviana.sh`
- **Uso regular:** `principales/busqueda_intermedia.sh`
- **Máxima cobertura:** `principales/busqueda_completa.sh`
- **Rutas específicas:** `especializados/busqueda_rutas_especificas.sh`
- **Crawling profundo:** `especializados/busqueda_avanzada_katana.sh`
- **Archivos ocultos:** `especializados/busqueda_archivos_ocultos.sh`
- **Solo subdominios:** `enumeracion/encontrar_subdominios_basico.sh`
- **Pentesting completo:** `pentesting/pentesting_completo.sh`

### Por Experiencia

- **Principiante:** `principales/busqueda_liviana.sh`
- **Intermedio:** `principales/busqueda_intermedia.sh`
- **Avanzado:** `principales/busqueda_completa.sh` o `pentesting/pentesting_completo.sh`

---

## 📦 Instalación de Dependencias

### Instalación Mínima (para scripts intermedios)

```bash
# Instalar Go
# macOS: brew install go
# Linux: sudo apt install golang-go

# Configurar PATH
export PATH=$PATH:$(go env GOPATH)/bin

# Herramientas esenciales
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest
```

### Instalación Completa (para scripts avanzados)

Ver las guías de instalación en cada carpeta:
- [Principales - Instalación](./principales/README.md#-instalación-rápida-para-intermedia-y-completa)
- [Pentesting - Instalación](./pentesting/README.md#-instalación-de-dependencias)

---

## 🔧 Configuración Común

### Permisos de Ejecución

```bash
# Dar permisos a todos los scripts
find . -name "*.sh" -exec chmod +x {} \;
```

### Configuración de PATH

Agregar a tu `~/.bashrc` o `~/.zshrc`:

```bash
export PATH=$PATH:$HOME/go/bin:$HOME/.local/bin
```

---

## 📋 Guía de Uso por Escenario

### Escenario 1: Prueba Rápida Sin Instalar Nada

```bash
cd principales
./busqueda_liviana.sh example.com
```

### Escenario 2: Auditoría Básica

```bash
cd principales
./busqueda_intermedia.sh example.com
```

### Escenario 3: Búsqueda en Ruta Específica

```bash
cd especializados
# Editar busqueda_rutas_especificas.sh
# Cambiar DOMINIO y RUTA_ESPECIFICA
./busqueda_rutas_especificas.sh
```

### Escenario 4: Auditoría Completa de Seguridad

```bash
cd pentesting
# Editar pentesting_completo.sh
# Cambiar URL_INPUT
./pentesting_completo.sh
```

---

## ⚠️ Notas Importantes

### Legalidad
- ✅ Solo usa estos scripts en dominios que **posees** o tienes **permiso explícito** para probar
- ❌ No uses en sistemas sin autorización (es ilegal)

### Rate Limits
- Respeta los rate limits de las APIs y servicios
- Algunos scripts hacen muchas peticiones HTTP
- Considera agregar delays en scripts de fuerza bruta

### Permisos
- Asegúrate de tener permisos de ejecución: `chmod +x *.sh`
- Verifica que las herramientas estén en tu PATH

### Edición Manual
- Algunos scripts requieren editar variables al inicio (DOMINIO, URL_INPUT, etc.)
- Lee los comentarios en cada script antes de ejecutar

---

## 🐛 Troubleshooting

### Error: "command not found"
```bash
# Verificar que las herramientas estén instaladas
which subfinder waybackurls gau katana

# Verificar PATH
echo $PATH
export PATH=$PATH:$HOME/go/bin
```

### Error: "Permission denied"
```bash
chmod +x nombre_script.sh
```

### Scripts muy lentos
- Usa `busqueda_liviana.sh` o `busqueda_intermedia.sh` para resultados más rápidos
- Limita el número de subdominios procesados en scripts grandes

### No encuentra resultados
- Verifica que el dominio sea correcto
- Algunos dominios tienen protección contra enumeración
- Prueba con diferentes scripts
- Verifica tu conexión a internet

---

## 📊 Estadísticas del Proyecto

- **Total de scripts:** 11
- **Categorías:** 4
- **Scripts sin dependencias:** 1
- **Scripts con dependencias mínimas:** 4
- **Scripts completos:** 6

---

## 🔄 Actualizaciones

### Mantener Herramientas Actualizadas

```bash
# Actualizar todas las herramientas Go
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/waybackurls@latest
go install github.com/lc/gau/v2/cmd/gau@latest
go install github.com/projectdiscovery/katana/cmd/katana@latest

# Actualizar plantillas de Nuclei (para pentesting)
nuclei -update-templates
```

---

## 📝 Licencia

Estos scripts son herramientas educativas. Úsalos responsablemente y solo en sistemas que posees o tienes permiso explícito para probar.

---

## 🤝 Contribuciones

Si mejoras algún script o encuentras bugs, siéntete libre de contribuir.

---

## 📚 Recursos Adicionales

- [ProjectDiscovery Tools](https://projectdiscovery.io/)
- [Go Installation Guide](https://go.dev/doc/install)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)

---

**Última actualización:** $(date)

**Estructura organizada por carpetas para fácil navegación y mantenimiento.**
