# Soporte SPM para KhenshinSecureMessage (eslabón #2) — Plan de Implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Disponibilizar `khipu/KhenshinSecureMessage` vía SPM (dual con CocoaPods), versión `1.4.1`, validando con los tests Quick/Nimble que la cripto sobre `tweetnacl-swiftwrap` es byte-compatible.

**Architecture:** `Package.swift` con dependencia a `tweetnacl-swiftwrap` (producto `TweetNacl`) y `testTarget` con Quick/Nimble apuntando a los tests existentes. El único cambio de código es un import condicional en `SecureMessage.swift` (`#if SWIFT_PACKAGE` → `TweetNacl`, `#else` → `KHTweetNaclSwift`), de modo que CocoaPods conserva su comportamiento. Release por el flujo existente `main` → `prod` (el `deploy.yml` crea el tag `1.4.1` y publica).

**Tech Stack:** Swift Package Manager (swift-tools 5.5), Quick/Nimble, CocoaPods (coexistencia), GitHub Actions.

**Spec de referencia:** `docs/superpowers/specs/2026-06-28-spm-khenshinsecuremessage-design.md`.

## Global Constraints

- `swift-tools-version: 5.5`; `platforms: [.iOS(.v12), .macOS(.v10_15)]` (macOS por los tests Quick/Nimble en `swift test`; el producto sigue soportando iOS 12).
- **No mover archivos**: target `path: "KhenshinSecureMessage/Classes"`; testTarget `path: "Example/Tests"`.
- **Único cambio de código permitido**: el import condicional en `SecureMessage.swift`. No alterar la lógica de cripto.
- **CocoaPods intacto**: el `.podspec` mantiene `s.dependency 'KHTweetNaclSwift', '1.1.0'`; solo se bumpea `s.version` a `1.4.1`.
- **Versionado: bump a `1.4.1`** (release normal, sin force-push).
- **Gate crítico**: `swift test` (tests Quick/Nimble de cripto) debe pasar. Si falla, NO continuar: escalar (posible cambio a portar `KHTweetNaclSwift`).
- Repo de trabajo: `~/git/KhenshinSecureMessage`. Ramas: `main` (desarrollo), `prod` (release).

---

### Task 1: Preparar el workspace

**Files:** Ninguno (setup sobre el clon existente).

**Interfaces:**
- Produces: rama `spm-support` desde `main`, base de las tareas siguientes.

- [ ] **Step 1: Sincronizar `main` y verificar estado**

```bash
cd ~/git/KhenshinSecureMessage
git checkout main && git pull --ff-only origin main
git status --porcelain && echo "(limpio)"
ls Package.swift 2>/dev/null || echo "no Package.swift (esperado)"
```
Expected: working tree limpio; `no Package.swift (esperado)`.

- [ ] **Step 2: Crear rama de trabajo**

```bash
git checkout -b spm-support
```

- [ ] **Step 3: Verificar estructura e imports actuales**

Run: `ls KhenshinSecureMessage/Classes/ Example/Tests/ && grep -nE "^import" KhenshinSecureMessage/Classes/SecureMessage.swift`
Expected: `SecureMessage.swift` existe; `Example/Tests/` tiene `KhenshinSecureMessageSpec.swift` e `Info.plist`; los imports incluyen `import KHTweetNaclSwift` en la línea 9.

---

### Task 2: `Package.swift`, import condicional y bump de versión

**Files:**
- Create: `~/git/KhenshinSecureMessage/Package.swift`
- Modify: `~/git/KhenshinSecureMessage/KhenshinSecureMessage/Classes/SecureMessage.swift` (import condicional)
- Modify: `~/git/KhenshinSecureMessage/KhenshinSecureMessage.podspec` (`s.version` → `1.4.1`)
- Modify: `~/git/KhenshinSecureMessage/.gitignore` (agregar `.build/`)

**Interfaces:**
- Consumes: producto `TweetNacl` de `tweetnacl-swiftwrap` (expone `NaclBox`, `NaclSecretBox`, idénticos a `KHTweetNaclSwift`).
- Produces: producto `.library("KhenshinSecureMessage")` con target homónimo + `testTarget` `KhenshinSecureMessageTests`.

- [ ] **Step 1: Import condicional en `SecureMessage.swift`**

Reemplazar exactamente esta línea:

```swift
import KHTweetNaclSwift
```

por:

```swift
#if SWIFT_PACKAGE
import TweetNacl
#else
import KHTweetNaclSwift
#endif
```

(No tocar nada más del archivo; el resto del código usa `NaclBox`/`NaclSecretBox`, disponibles en ambos módulos.)

- [ ] **Step 2: Bump de versión en el podspec**

En `KhenshinSecureMessage.podspec`, cambiar:

```ruby
  s.version          = '1.4.0'
```
por:
```ruby
  s.version          = '1.4.1'
```
(No cambiar `s.dependency 'KHTweetNaclSwift', '1.1.0'`.)

- [ ] **Step 3: Crear el `Package.swift`**

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KhenshinSecureMessage",
    platforms: [.iOS(.v12), .macOS(.v10_15)],
    products: [
        .library(name: "KhenshinSecureMessage", targets: ["KhenshinSecureMessage"])
    ],
    dependencies: [
        .package(url: "https://github.com/khipu/tweetnacl-swiftwrap.git", from: "1.1.5"),
        .package(url: "https://github.com/Quick/Quick.git", from: "7.0.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "13.0.0")
    ],
    targets: [
        .target(
            name: "KhenshinSecureMessage",
            dependencies: [.product(name: "TweetNacl", package: "tweetnacl-swiftwrap")],
            path: "KhenshinSecureMessage/Classes"
        ),
        .testTarget(
            name: "KhenshinSecureMessageTests",
            dependencies: ["KhenshinSecureMessage", "Quick", "Nimble"],
            path: "Example/Tests",
            exclude: ["Info.plist"]
        )
    ]
)
```

- [ ] **Step 4: Ignorar artefactos SPM**

Agregar al final de `.gitignore`:

```
# Swift Package Manager
.build/
```

- [ ] **Step 5: Compilar el target de librería**

Run: `swift build`
Expected: PASS — `Build complete!`. SPM resuelve `tweetnacl-swiftwrap` y compila `KhenshinSecureMessage` contra `TweetNacl`. Si la resolución de paquetes falla por versiones de Quick/Nimble incompatibles con la toolchain, ajustar los pisos (`from:`) a la última versión compatible disponible y reintentar; documentar el ajuste en el reporte.

- [ ] **Step 6: Commit**

```bash
git add Package.swift .gitignore KhenshinSecureMessage/Classes/SecureMessage.swift KhenshinSecureMessage.podspec
git commit -m "feat: soporte SPM con import condicional de cripto y bump 1.4.1"
```

---

### Task 3: Gate de cripto — `swift test` (Quick/Nimble)

**Files:** Ninguno nuevo (corre los tests existentes vía el testTarget de la Task 2).

**Interfaces:**
- Consumes: `testTarget` `KhenshinSecureMessageTests` y el módulo `TweetNacl`.
- Produces: evidencia empírica de que la cripto sobre `tweetnacl-swiftwrap` es compatible (resuelve la duda de los "compatibility issues").

- [ ] **Step 1: Ejecutar los tests SPM**

Run: `swift test`
Expected: PASS — corren los specs Quick/Nimble (`Should create a public key`, `encrypt and decrypt cycle`, `decryptMultipleMessagesWithMultipleSecureMessageInstances`, `decryptMultipleMessagesWithSameSymetricKey`, `symmetric encrypt/decrypt`), todos en verde.

> **GATE CRÍTICO.** Si algún test de cripto falla, DETENTE y reporta `BLOCKED` con la salida. No continúes: significa que `TweetNacl` no es byte-compatible y hay que escalar a portar `KHTweetNaclSwift` (cambio de enfoque del spec).

- [ ] **Step 2: (Sin commit)** — esta tarea es un gate de verificación; no produce cambios.

---

### Task 4: Workflow de CI para SPM

**Files:**
- Create: `~/git/KhenshinSecureMessage/.github/workflows/spm.yml`

**Interfaces:**
- Produces: workflow `SPM Build & Test` que valida `swift build` + `swift test` en PRs y pushes a `main`.

- [ ] **Step 1: Crear el workflow**

```yaml
name: SPM Build & Test

on:
  push:
    branches: [main]
  pull_request:
  workflow_dispatch:

jobs:
  spm:
    name: swift build & test
    runs-on: macos-15
    steps:
      - uses: actions/checkout@v4
      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_16.4.app
      - name: Build
        run: swift build
      - name: Test
        run: swift test
```

- [ ] **Step 2: Validar el YAML**

Run: `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/spm.yml')); print('YAML OK')"`
Expected: `YAML OK`.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/spm.yml
git commit -m "ci: agregar workflow SPM (swift build & test)"
```

---

### Task 5: Documentar el soporte SPM

**Files:**
- Modify: `~/git/KhenshinSecureMessage/README.md`

**Interfaces:**
- Produces: documentación de instalación SPM.

- [ ] **Step 1: Agregar sección SPM al README**

Insertar bajo la sección de instalación existente:

```markdown
## Installation (Swift Package Manager)

Add the package to your `Package.swift` dependencies:

    .package(url: "https://github.com/khipu/KhenshinSecureMessage.git", from: "1.4.1")

Then add `KhenshinSecureMessage` to your target's dependencies, or in Xcode use
**File → Add Package Dependencies…** with the same URL.

> En SPM la criptografía se provee vía `tweetnacl-swiftwrap` (módulo `TweetNacl`);
> en CocoaPods vía `KHTweetNaclSwift`. La API (`NaclBox`/`NaclSecretBox`) es idéntica
> y la compatibilidad está cubierta por los tests.
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: documentar instalación vía SPM"
```

---

### Task 6: Verificar que CocoaPods sigue intacto

**Files:** Ninguno (verificación).

**Interfaces:**
- Produces: evidencia de que el pod valida con la nueva versión y el import condicional.

- [ ] **Step 1: Lint del pod**

Run: `pod lib lint --allow-warnings`
Expected: PASS — `KhenshinSecureMessage passed validation.`. En CocoaPods `SWIFT_PACKAGE` no está definido, así que se compila la rama `#else import KHTweetNaclSwift`; el bump a `1.4.1` no afecta el lint.

> Si `pod lib lint` requiere instalar el pod `KHTweetNaclSwift` y falla por red/credenciales, registrarlo; el gate definitivo de CocoaPods es el `deploy.yml` en el release (Task 8).

---

### Task 7: Validar consumo como paquete (consumidor real, pre-release)

**Files:**
- Create (temporal, scratchpad): proyecto consumidor desechable.

**Interfaces:**
- Consumes: el paquete local vía `.package(path:)`.
- Produces: evidencia de que un consumidor externo resuelve, importa y usa la cripto. No se commitea.

- [ ] **Step 1: Crear el consumidor temporal**

```bash
SCRATCH="/private/tmp/claude-501/-Users-edavis-git-KhipuClientIOS/f589e031-ced9-4f68-acc1-7ab642bef6e3/scratchpad"
mkdir -p "$SCRATCH/SMConsumer/Sources/SMConsumer"
cd "$SCRATCH/SMConsumer"
```

- [ ] **Step 2: `Package.swift` del consumidor (path absoluto)**

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SMConsumer",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(path: "/Users/edavis/git/KhenshinSecureMessage")
    ],
    targets: [
        .executableTarget(
            name: "SMConsumer",
            dependencies: [
                .product(name: "KhenshinSecureMessage", package: "KhenshinSecureMessage")
            ]
        )
    ]
)
```

- [ ] **Step 3: Consumidor mínimo con round-trip de cripto**

Crear `Sources/SMConsumer/main.swift`:

```swift
import KhenshinSecureMessage

let alice = SecureMessage(publicKeyBase64: nil, privateKeyBase64: nil)
let bob = SecureMessage(publicKeyBase64: nil, privateKeyBase64: nil)

let cipher = alice.encrypt(plainText: "hola", receiverPublicKeyBase64: bob.publicKeyBase64)!
let plain = bob.decrypt(cipherText: cipher, senderPublicKey: alice.publicKeyBase64)!
print("round-trip: \(plain)")
precondition(plain == "hola", "el round-trip de cripto debe devolver el texto original")
```

- [ ] **Step 4: Ejecutar**

Run: `swift run`
Expected: PASS — imprime `round-trip: hola`.

- [ ] **Step 5: Limpiar**

```bash
cd ~ && rm -rf "$SCRATCH/SMConsumer"
```

---

### Task 8: Release `1.4.1` (main → prod) — REQUIERE confirmación humana

**Files:** Ninguno nuevo (operaciones de git + CI).

**Interfaces:**
- Consumes: rama `spm-support` validada.
- Produces: `1.4.1` publicado, tag con `Package.swift`, consumible por SPM y CocoaPods.

> **Operación sensible:** publica a CocoaPods trunk y crea un tag de versión. Confirmar con el usuario antes de los Steps 3-4.

- [ ] **Step 1: Push de la rama y PR a `main`**

```bash
cd ~/git/KhenshinSecureMessage
git push -u origin spm-support
gh pr create --base main --head spm-support \
  --title "Soporte SPM (dual con CocoaPods) — 1.4.1" \
  --body "Agrega Package.swift, import condicional de cripto (TweetNacl en SPM / KHTweetNaclSwift en CocoaPods), testTarget Quick/Nimble, workflow SPM y docs. Bump a 1.4.1. Validado: swift build, swift test (cripto), pod lib lint, consumidor SPM."
```
Expected: el workflow `SPM Build & Test` corre en el PR y queda verde.

- [ ] **Step 2: Merge a `main`**

Tras CI verde, hacer merge del PR (vía `gh pr merge --merge` o UI). `run-tests.yml` correrá en `main` (Example vía CocoaPods, rama `#else`).

- [ ] **Step 3: Promover `main` → `prod` (dispara el deploy)**

```bash
git checkout prod && git pull --ff-only origin prod
git merge --no-ff main -m "release: 1.4.1 con soporte SPM"
git push origin prod
```
Esto dispara `deploy.yml`: crea el tag `1.4.1` (desde el podspec, sobre un árbol que ya incluye `Package.swift`) y hace `pod trunk push`.

- [ ] **Step 4: Verificar el deploy y el tag**

```bash
gh run list --branch prod --limit 3
git fetch --tags origin
git ls-tree --name-only 1.4.1 | grep Package.swift && echo "Package.swift en tag 1.4.1 ✅"
```
Expected: el run de `Deploy to Cocoapods` termina en `success`; el tag `1.4.1` contiene `Package.swift`.

- [ ] **Step 5: Validación final de consumidor remoto**

```bash
SCRATCH="/private/tmp/claude-501/-Users-edavis-git-KhipuClientIOS/f589e031-ced9-4f68-acc1-7ab642bef6e3/scratchpad"
mkdir -p "$SCRATCH/SMRemote/Sources/SMRemote"
cd "$SCRATCH/SMRemote"
cat > Package.swift <<'PKG'
// swift-tools-version:5.5
import PackageDescription
let package = Package(
    name: "SMRemote",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/khipu/KhenshinSecureMessage.git", .exact("1.4.1"))
    ],
    targets: [
        .executableTarget(name: "SMRemote", dependencies: [
            .product(name: "KhenshinSecureMessage", package: "KhenshinSecureMessage")
        ])
    ]
)
PKG
cat > Sources/SMRemote/main.swift <<'SWIFT'
import KhenshinSecureMessage
let a = SecureMessage(publicKeyBase64: nil, privateKeyBase64: nil)
let b = SecureMessage(publicKeyBase64: nil, privateKeyBase64: nil)
let c = a.encrypt(plainText: "ok", receiverPublicKeyBase64: b.publicKeyBase64)!
print(b.decrypt(cipherText: c, senderPublicKey: a.publicKeyBase64)!)
SWIFT
rm -rf .build Package.resolved ~/Library/Caches/org.swift.swiftpm/repositories
swift run
cd ~ && rm -rf "$SCRATCH/SMRemote"
```
Expected: PASS — SPM resuelve `KhenshinSecureMessage` en `1.4.1` e imprime `ok`.

- [ ] **Step 6: Limpieza de la rama**

```bash
cd ~/git/KhenshinSecureMessage
git push origin --delete spm-support 2>/dev/null; git checkout main && git branch -D spm-support
```

---

## Cierre y siguiente eslabón

Al completar Task 8, `KhenshinSecureMessage 1.4.1` es consumible por SPM y CocoaPods, con la cripto validada por tests.

**Gate antes de avanzar:** `swift build`, `swift test` (cripto), `pod lib lint`, consumidor remoto `1.4.1` — todos en verde.

**Siguiente:** eslabón #3 (`KhipuClientIOS`) — el objetivo final: deps Socket.IO + Starscream + KhenshinProtocol + KhenshinSecureMessage, manejo de recursos (`Bundle.module`) y migración de la suite ViewInspector a testTarget SPM.

## Self-Review

- **Cobertura del spec:** import condicional (Task 2) ✓; Package.swift con TweetNacl + Quick/Nimble (Task 2) ✓; bump 1.4.1 (Task 2) ✓; gate `swift test` cripto (Task 3) ✓; spm.yml build+test (Task 4) ✓; docs (Task 5) ✓; pod lib lint (Task 6) ✓; consumidor real (Tasks 7 y 8) ✓; release main→prod (Task 8) ✓.
- **Placeholders:** sin TBD; versiones concretas (1.1.5/7.0.0/13.0.0) con contingencia explícita; código de import condicional y consumidores completo.
- **Consistencia de tipos:** producto/target `KhenshinSecureMessage`; `.product(name: "TweetNacl", package: "tweetnacl-swiftwrap")` consistente en Package.swift y consumidores; API `SecureMessage(publicKeyBase64:privateKeyBase64:)`, `encrypt(plainText:receiverPublicKeyBase64:)`, `decrypt(cipherText:senderPublicKey:)` coincide con el código real de `SecureMessage.swift`.
