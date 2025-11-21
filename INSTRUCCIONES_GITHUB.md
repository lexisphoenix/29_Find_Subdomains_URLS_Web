# 🚀 Instrucciones para Subir a GitHub

## Opción 1: Usar GitHub CLI (Recomendado)

Si tienes GitHub CLI instalado:

```bash
# 1. Autenticarte (si no lo has hecho)
gh auth login

# 2. Crear y subir el repositorio
gh repo create 29_Find_Subdomains_URLS_Web \
  --public \
  --description "Colección completa de scripts para enumeración de subdominios y URLs" \
  --source=. \
  --remote=origin \
  --push
```

## Opción 2: Crear Manualmente (Paso a Paso)

### Paso 1: Crear el repositorio en GitHub

1. Ve a https://github.com/new
2. **Repository name:** `29_Find_Subdomains_URLS_Web`
3. **Description:** `Colección completa de scripts para enumeración de subdominios y URLs. Desde versiones ultra-livianas sin dependencias hasta suites completas de pentesting.`
4. Elige **Public** o **Private**
5. ⚠️ **NO marques** "Add a README file" (ya tenemos uno)
6. ⚠️ **NO marques** "Add .gitignore" (ya tenemos uno)
7. Haz clic en **"Create repository"**

### Paso 2: Conectar y subir el código

**Si usas HTTPS:**

```bash
# Reemplaza TU_USUARIO con tu nombre de usuario de GitHub
git remote add origin https://github.com/TU_USUARIO/29_Find_Subdomains_URLS_Web.git
git branch -M main
git push -u origin main
```

**Si usas SSH:**

```bash
# Reemplaza TU_USUARIO con tu nombre de usuario de GitHub
git remote add origin git@github.com:TU_USUARIO/29_Find_Subdomains_URLS_Web.git
git branch -M main
git push -u origin main
```

### Paso 3: Verificar

Ve a tu repositorio en GitHub y verifica que todos los archivos se hayan subido correctamente.

---

## 🔐 Autenticación

Si GitHub te pide credenciales:

### Para HTTPS:
- Usa un **Personal Access Token** en lugar de tu contraseña
- Crea uno en: https://github.com/settings/tokens
- Selecciona el scope `repo`

### Para SSH:
- Asegúrate de tener tu clave SSH configurada
- Agrega tu clave en: https://github.com/settings/keys

---

## ✅ Verificación Final

Después de subir, deberías ver:

- ✅ README.md principal
- ✅ 4 carpetas: principales/, especializados/, enumeracion/, pentesting/
- ✅ Todos los scripts .sh
- ✅ README.md en cada carpeta
- ✅ .gitignore

---

## 🔄 Actualizaciones Futuras

Para subir cambios futuros:

```bash
git add .
git commit -m "Descripción de los cambios"
git push
```

---

## 📝 Notas

- El repositorio ya está inicializado localmente
- Todos los archivos están listos para subir
- El .gitignore excluye archivos de resultados y temporales
- La rama principal se llama `main`

