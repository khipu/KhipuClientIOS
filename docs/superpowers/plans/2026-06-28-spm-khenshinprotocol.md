# Soporte SPM para KhenshinProtocol — Plan de Implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Disponibilizar el repo `khipu/KhenshinProtocolSwift` vía Swift Package Manager (SPM) en paralelo a CocoaPods, sin bump de versión, dejando la versión `1.0.60` consumible por SPM.

**Architecture:** Se agrega un `Package.swift` estático **solo-librería** que reutiliza la estructura actual del repo mediante `path:` (sin mover archivos). El código es 100% auto-generado por quicktype, por lo que **no se escriben tests a mano** (si hubiera tests serían generados también); la validación es `swift build` + una prueba de consumidor real. El `.podspec` queda intacto (distribución dual). El generador `khenshin-websocket-schema` **no se toca**; el `Package.swift` sobrevive a las regeneraciones porque el pipeline solo reescribe `KhenshinProtocol.swift` y `s.version`. La versión `1.0.60` se habilita en SPM re-etiquetando el tag al commit que incluye el manifiesto.

**Tech Stack:** Swift Package Manager (swift-tools 5.5), Swift 5, CocoaPods (coexistencia), GitHub Actions.

**Spec de referencia:** `docs/superpowers/specs/2026-06-28-spm-migration-design.md` (§4).

## Global Constraints

- `swift-tools-version: 5.5`; `platforms: [.iOS(.v12)]`.
- **No mover archivos**: el target SPM usa `path: "KhenshinProtocol/Classes"`.
- **Package.swift solo-librería**: sin `testTarget` (código 100% generado, sin tests reales). No crear tests a mano.
- **Mantener el `.podspec` intacto** (distribución dual CocoaPods + SPM).
- **No bump de versión**: mantener `1.0.60`. La versión la controla el generador.
- **No modificar** el repo generador `khenshin-websocket-schema`.
- **No modificar** `KhenshinProtocol/Classes/KhenshinProtocol.swift` (archivo auto-generado por quicktype).
- Mismo tag git sirve a CocoaPods y SPM. El repo destino es **público**.
- Todo el trabajo ocurre en un clon del repo `khipu/KhenshinProtocolSwift`, **no** en `KhipuClientIOS` (que solo aloja el spec y este plan).

---

### Task 1: Preparar el workspace del repo destino

**Files:**
- Ninguno (operación de setup sobre un clon de `khipu/KhenshinProtocolSwift`).

**Interfaces:**
- Consumes: nada.
- Produces: clon local del repo en rama de trabajo `spm-support`, base para todas las tareas siguientes.

- [ ] **Step 1: Clonar el repo destino (si no existe)**

```bash
cd ~/git
[ -d KhenshinProtocolSwift ] || git clone git@github.com:khipu/KhenshinProtocolSwift.git
cd ~/git/KhenshinProtocolSwift
git checkout main
git pull --ff-only origin main
```

- [ ] **Step 2: Confirmar estado limpio y ausencia de Package.swift**

Run: `git status --porcelain && ls Package.swift 2>/dev/null || echo "no Package.swift (esperado)"`
Expected: salida vacía de `git status` y la línea `no Package.swift (esperado)`.

- [ ] **Step 3: Crear la rama de trabajo**

```bash
git checkout -b spm-support
```

- [ ] **Step 4: Verificar la estructura que consumirá el manifiesto**

Run: `ls KhenshinProtocol/Classes/`
Expected: contiene `KhenshinProtocol.swift` (y `.gitkeep`).

---

### Task 2: `Package.swift` solo-librería

**Files:**
- Create: `~/git/KhenshinProtocolSwift/Package.swift`
- Modify: `~/git/KhenshinProtocolSwift/.gitignore` (agregar `.build/`)

**Interfaces:**
- Consumes: el módulo `KhenshinProtocol` (definido por el código generado), Foundation puro.
- Produces: producto SPM `.library(name: "KhenshinProtocol")` con target `KhenshinProtocol`. Estos nombres los consumirán la prueba de consumidor (Tasks 6/7) y los eslabones #2/#3.

- [ ] **Step 1: Verificar que `swift build` falla sin manifiesto (estado inicial)**

Run: `cd ~/git/KhenshinProtocolSwift && swift build`
Expected: FALLA. Sin `Package.swift`, SwiftPM reporta `error: could not find Package.swift in this directory or any of its parent directories`.

- [ ] **Step 2: Crear el `Package.swift`**

Crear `Package.swift` en la raíz:

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KhenshinProtocol",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "KhenshinProtocol", targets: ["KhenshinProtocol"])
    ],
    targets: [
        .target(
            name: "KhenshinProtocol",
            path: "KhenshinProtocol/Classes"
        )
    ]
)
```

- [ ] **Step 3: Ignorar artefactos de build de SPM**

Agregar al final de `.gitignore`:

```
# Swift Package Manager
.build/
```

- [ ] **Step 4: Compilar el paquete**

Run: `swift build`
Expected: PASS — `Build complete!` (el target `KhenshinProtocol` compila como Foundation puro). Si SwiftPM avisa sobre `.gitkeep`, es inofensivo; el target solo compila `.swift`.

- [ ] **Step 5: Commit**

```bash
git add Package.swift .gitignore
git commit -m "feat: agregar Package.swift (soporte SPM, solo-librería)"
```

---

### Task 3: Verificar que CocoaPods sigue intacto

**Files:**
- Ninguno (verificación; no se modifica el `.podspec`).

**Interfaces:**
- Consumes: `KhenshinProtocol.podspec` (sin cambios), `Package.swift` (Task 2).
- Produces: evidencia de que el pod sigue validando — gate para no romper la distribución CocoaPods existente.

- [ ] **Step 1: Confirmar que el podspec no se tocó y que Package.swift no entra en source_files**

Run: `git diff main -- KhenshinProtocol.podspec; grep source_files KhenshinProtocol.podspec`
Expected: sin diff en el podspec; `s.source_files = 'KhenshinProtocol/Classes/**/*'` (el `Package.swift` está en la raíz, fuera de ese glob).

- [ ] **Step 2: Lint del pod**

Run: `pod lib lint --allow-warnings`
Expected: PASS — `KhenshinProtocol passed validation.` (mismo resultado que antes de agregar SPM; el `Package.swift` no afecta el lint).

> Si `pod` no está instalado en el entorno, registrar que este gate debe correr en CI/Mac con CocoaPods antes del release (Task 7).

---

### Task 4: Workflow de CI para SPM

**Files:**
- Create: `~/git/KhenshinProtocolSwift/.github/workflows/spm.yml`

**Interfaces:**
- Consumes: `Package.swift` (Task 2).
- Produces: workflow `SPM Build` que valida `swift build` en PRs y pushes a `main`, y permite ejecución manual. No interfiere con `run-tests.yml` ni `deploy.yml`.

- [ ] **Step 1: Crear el workflow**

Crear `.github/workflows/spm.yml`:

```yaml
name: SPM Build

on:
  push:
    branches: [main]
  pull_request:
  workflow_dispatch:

jobs:
  spm:
    name: swift build
    runs-on: macos-15
    steps:
      - uses: actions/checkout@v4
      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_16.4.app
      - name: Build
        run: swift build
```

- [ ] **Step 2: Validar el YAML localmente**

Run: `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/spm.yml')); print('YAML OK')"`
Expected: `YAML OK`.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/spm.yml
git commit -m "ci: agregar workflow SPM (swift build)"
```

---

### Task 5: Documentar el soporte SPM en el repo destino

**Files:**
- Modify: `~/git/KhenshinProtocolSwift/README.md`
- Modify: `~/git/KhenshinProtocolSwift/CLAUDE.md` (si existe; si no, omitir ese archivo)

**Interfaces:**
- Consumes: nada de código.
- Produces: documentación de instalación SPM y nota de que el `Package.swift` es estático y persiste a las regeneraciones del generador.

- [ ] **Step 1: Agregar sección SPM al README**

Insertar en `README.md`, bajo la sección de instalación existente:

```markdown
## Installation (Swift Package Manager)

Add the package to your `Package.swift` dependencies:

    .package(url: "https://github.com/khipu/KhenshinProtocolSwift.git", from: "1.0.60")

Then add `KhenshinProtocol` to your target's dependencies. In Xcode:
**File → Add Packages…** and use the same URL.

> **Nota de mantenimiento:** el `Package.swift` es estático y vive en este repo.
> El pipeline de `khenshin-websocket-schema` solo regenera
> `KhenshinProtocol/Classes/KhenshinProtocol.swift` y la versión del `.podspec`,
> por lo que el manifiesto SPM sobrevive a cada regeneración sin intervención.
```

- [ ] **Step 2: (Si existe `CLAUDE.md`) registrar la nota de mantenimiento**

Si el repo tiene `CLAUDE.md`, agregar una línea bajo su sección de arquitectura/convenciones:

```markdown
- El repo soporta SPM vía `Package.swift` estático y solo-librería (dual con CocoaPods). El generador no lo gestiona; persiste entre regeneraciones.
```

- [ ] **Step 3: Commit**

```bash
git add README.md CLAUDE.md 2>/dev/null; git add README.md
git commit -m "docs: documentar instalación vía SPM"
```

---

### Task 6: Validar consumo como paquete (consumidor real, pre-tag)

**Files:**
- Create (temporal, en el scratchpad): `.../scratchpad/SPMConsumerTest/Package.swift`
- Create (temporal): `.../scratchpad/SPMConsumerTest/Sources/SPMConsumerTest/main.swift`

**Interfaces:**
- Consumes: el paquete local `KhenshinProtocol` vía `.package(path:)` apuntando al clon (valida la resolución como dependencia antes de tocar el tag remoto).
- Produces: evidencia de que un consumidor externo resuelve, importa y usa el módulo. Esto **no** es un test del repo generado: es un proyecto desechable de validación que no se commitea.

- [ ] **Step 1: Crear el proyecto consumidor temporal**

```bash
SCRATCH="/private/tmp/claude-501/-Users-edavis-git-KhipuClientIOS/f589e031-ced9-4f68-acc1-7ab642bef6e3/scratchpad"
mkdir -p "$SCRATCH/SPMConsumerTest/Sources/SPMConsumerTest"
cd "$SCRATCH/SPMConsumerTest"
```

- [ ] **Step 2: Escribir el `Package.swift` del consumidor (dependencia por path absoluto)**

Crear `$SCRATCH/SPMConsumerTest/Package.swift`:

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SPMConsumerTest",
    dependencies: [
        .package(path: "/Users/edavis/git/KhenshinProtocolSwift")
    ],
    targets: [
        .executableTarget(
            name: "SPMConsumerTest",
            dependencies: [
                .product(name: "KhenshinProtocol", package: "KhenshinProtocolSwift")
            ]
        )
    ]
)
```

- [ ] **Step 3: Escribir un consumidor mínimo**

Crear `$SCRATCH/SPMConsumerTest/Sources/SPMConsumerTest/main.swift`:

```swift
import KhenshinProtocol

print("Consumido KhenshinProtocol: \(MessageType.userCanceled.rawValue)")
precondition(MessageType.userCanceled.rawValue == "USER_CANCELED")
```

- [ ] **Step 4: Compilar y ejecutar el consumidor**

Run: `swift run`
Expected: PASS — imprime `Consumido KhenshinProtocol: USER_CANCELED`.

- [ ] **Step 5: Limpiar el proyecto temporal**

```bash
cd ~ && rm -rf "$SCRATCH/SPMConsumerTest"
```

No hay commit en esta tarea (el proyecto es temporal y se descarta).

---

### Task 7: Release — llevar a `main` sin gatillar deploy y mover el tag `1.0.60`

**Files:**
- Ninguno nuevo (operaciones de git sobre `khipu/KhenshinProtocolSwift`).

**Interfaces:**
- Consumes: rama `spm-support` validada (Tasks 2-6).
- Produces: `main` con el soporte SPM y el tag `1.0.60` re-apuntado al commit que incluye `Package.swift` → SPM consumible por `from: "1.0.60"`.

> **Operación delicada:** force-push de un tag publicado. Es segura porque el `.swift` y el `.podspec` no cambian (el pod resultante es idéntico). Confirmar con el responsable del repo antes de ejecutar el Step 4/5.

- [ ] **Step 1: (Opcional pero recomendado) abrir PR para correr el CI de SPM**

```bash
cd ~/git/KhenshinProtocolSwift
git push -u origin spm-support
gh pr create --title "Soporte SPM (dual con CocoaPods)" \
  --body "Agrega Package.swift solo-librería, workflow SPM y docs. No cambia el .podspec ni el código generado. Ver spec KhipuClientIOS docs/superpowers/specs/2026-06-28-spm-migration-design.md"
```
Expected: el workflow `SPM Build` corre en el PR y queda verde. (Revisar en la pestaña Actions / checks del PR.)

- [ ] **Step 2: Integrar a `main` con `[skip ci]`**

El mensaje del commit de merge **debe** contener `[skip ci]` para no disparar `run-tests.yml` → `deploy.yml` (que intentaría re-publicar `1.0.60` en CocoaPods trunk y fallaría):

```bash
git checkout main
git pull --ff-only origin main
git merge --no-ff spm-support -m "feat: soporte SPM (dual con CocoaPods) [skip ci]"
git push origin main
```

- [ ] **Step 3: Verificar que `main` quedó con el manifiesto y que ningún workflow se disparó**

Run: `git ls-tree --name-only HEAD | grep Package.swift && gh run list --branch main --limit 3`
Expected: `Package.swift` listado; la corrida más reciente NO corresponde a este push (gracias a `[skip ci]`).

- [ ] **Step 4: Mover el tag `1.0.60` al commit de `main`**

```bash
git tag -f -a 1.0.60 -m "version 1.0.60 (SPM enabled)" HEAD
git push -f origin refs/tags/1.0.60
```

- [ ] **Step 5: Verificar el contenido del tag**

Run: `git ls-tree --name-only 1.0.60 | grep Package.swift`
Expected: `Package.swift` aparece en el árbol del tag `1.0.60`.

- [ ] **Step 6: Validación final de consumidor remoto por versión**

```bash
SCRATCH="/private/tmp/claude-501/-Users-edavis-git-KhipuClientIOS/f589e031-ced9-4f68-acc1-7ab642bef6e3/scratchpad"
mkdir -p "$SCRATCH/SPMConsumerRemote/Sources/SPMConsumerRemote"
cd "$SCRATCH/SPMConsumerRemote"
```

Crear `Package.swift`:

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SPMConsumerRemote",
    dependencies: [
        .package(url: "https://github.com/khipu/KhenshinProtocolSwift.git", exact: "1.0.60")
    ],
    targets: [
        .executableTarget(
            name: "SPMConsumerRemote",
            dependencies: [
                .product(name: "KhenshinProtocol", package: "KhenshinProtocolSwift")
            ]
        )
    ]
)
```

Crear `Sources/SPMConsumerRemote/main.swift`:

```swift
import KhenshinProtocol
print(MessageType.userCanceled.rawValue)
```

- [ ] **Step 7: Resolver desde el tag remoto (caché limpia) y ejecutar**

Run:
```bash
rm -rf .build Package.resolved ~/Library/Caches/org.swift.swiftpm/repositories
swift run
```
Expected: PASS — SwiftPM clona `KhenshinProtocolSwift` en `1.0.60`, resuelve, y `swift run` imprime `USER_CANCELED`. Esto confirma que el tag movido es consumible por SPM.

- [ ] **Step 8: Limpiar**

```bash
cd ~ && rm -rf "$SCRATCH/SPMConsumerRemote"
```

---

## Cierre y siguiente eslabón

Al completar Task 7, `KhenshinProtocol` 1.0.60 es consumible por SPM y CocoaPods. Los próximos releases automáticos del generador heredarán el `Package.swift` sin intervención.

**Gate antes de avanzar:** todos los pasos de verificación en verde (swift build, pod lib lint, consumidor remoto por `1.0.60`).

**Siguiente:** eslabón #2 (`KhenshinSecureMessage`) tendrá su propio spec + plan (ver §5 del spec): `Package.swift` con dependencia a `tweetnacl-swiftwrap` (producto `TweetNacl`) e import condicional en `SecureMessage.swift`.

## Self-Review

- **Cobertura del spec (§4):** Package.swift solo-librería (Task 2) ✓; workflow spm.yml (Task 4) ✓; doc README/CLAUDE (Task 5) ✓; verificación swift build (Task 2), pod lib lint (Task 3), consumidor real (Tasks 6 y 7) ✓; estrategia de tag — commit `[skip ci]` + force-move 1.0.60 (Task 7) ✓; no tocar generador (Global Constraints) ✓.
- **Sin tests a mano:** acorde a que el código es 100% generado; no se crean tests. La validación es `swift build` + consumidor desechable (no commiteado).
- **Placeholders:** sin TBD/TODO; todo el código (manifiestos, consumidores) es concreto y usa tipos reales (`MessageType.userCanceled`).
- **Consistencia de tipos:** producto `KhenshinProtocol` y target `KhenshinProtocol` se nombran igual en Task 2 y se consumen idénticos en Tasks 6/7 (`.product(name: "KhenshinProtocol", package: "KhenshinProtocolSwift")`); `MessageType.userCanceled` coincide con el caso real del código generado.
