# Soporte SPM para KhipuClientIOS (eslabón #3) — Plan de Implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Disponibilizar `KhipuClientIOS` vía SPM (dual con CocoaPods), versión `2.16.3`, con recursos vía `Bundle.module` y la suite ViewInspector corriendo en SPM (xcodebuild + simulador iOS).

**Architecture:** `Package.swift` con `path: "KhipuClientIOS"`, `sources: ["Classes"]`, `resources: [.process("Assets")]`, deps `SocketIO` + `KhenshinProtocol 1.0.60` + `KhenshinSecureMessage 1.4.1` (Starscream es transitiva). El acceso a recursos se centraliza en `KhipuClientBundleHelper` (`Bundle.module` en SPM, bundle nombrado en CocoaPods) + `FontLoader`. Paquete **iOS-only** → build/test con `xcodebuild`. Release `master` → `prod`.

**Tech Stack:** SPM (swift-tools 5.5), SwiftUI/UIKit, xcodebuild + simulador iOS, ViewInspector 0.10.3, CocoaPods (coexistencia), GitHub Actions.

**Spec de referencia:** `docs/superpowers/specs/2026-06-28-spm-khipuclientios-design.md`.

## Global Constraints

- `swift-tools-version: 5.5`; `platforms: [.iOS(.v13)]`.
- **No mover archivos**: target `path: "KhipuClientIOS"`, `sources: ["Classes"]`, `resources: [.process("Assets")]`; testTarget `path: "Example/Tests"`.
- **Paquete iOS-only**: NUNCA validar con `swift build`/`swift test` (fallan en macOS por UIKit/SwiftUI). Usar SIEMPRE `xcodebuild` + simulador iOS.
- **Cambios de código permitidos**: solo el acceso a recursos (`KhipuClientBundleHelper` y `FontLoader`) con `#if SWIFT_PACKAGE`. No alterar lógica de negocio/UI.
- **CocoaPods intacto**: el `.podspec` mantiene sus `s.dependency`; solo se bumpea `s.version` a `2.16.3`.
- **Deps directas**: `SocketIO`, `KhenshinProtocol`, `KhenshinSecureMessage`. NO declarar Starscream.
- Repo de trabajo: este repo (`~/git/KhipuClientIOS`), rama `spm-migration`. Release vía `master` → `prod`.

---

### Task 1: Preparar y limpiar Assets

**Files:**
- Delete (del índice git): `KhipuClientIOS/Assets/.DS_Store`, `KhipuClientIOS/Assets/Resources/.DS_Store`, `KhipuClientIOS/Assets/Resources/Colors.xcassets/.DS_Store`
- Modify: `.gitignore` (asegurar `.build/`)

**Interfaces:**
- Produces: árbol de Assets sin `.DS_Store` (para que `.process("Assets")` no los trate como recursos).

- [ ] **Step 1: Confirmar rama y estado**

Run: `cd ~/git/KhipuClientIOS && git branch --show-current && git status --porcelain | head`
Expected: rama `spm-migration`.

- [ ] **Step 2: Eliminar los `.DS_Store` trackeados bajo Assets**

```bash
git rm --cached KhipuClientIOS/Assets/.DS_Store \
  KhipuClientIOS/Assets/Resources/.DS_Store \
  KhipuClientIOS/Assets/Resources/Colors.xcassets/.DS_Store
find KhipuClientIOS/Assets -name .DS_Store -delete
```

- [ ] **Step 3: Asegurar `.build/` en `.gitignore`**

Run: `grep -q "^.build/" .gitignore || printf '\n# Swift Package Manager\n.build/\n' >> .gitignore`
Expected: `.gitignore` contiene `.build/`.

- [ ] **Step 4: Commit**

```bash
git add -A .gitignore KhipuClientIOS/Assets
git commit -m "chore: limpiar .DS_Store de Assets y preparar SPM"
```

---

### Task 2: Acceso a recursos condicional (Bundle.module)

**Files:**
- Modify: `KhipuClientIOS/Classes/SwiftUiClient/Util/BundleHelper.swift`
- Modify: `KhipuClientIOS/Classes/SwiftUiClient/Themes/FontLoader.swift`

**Interfaces:**
- Produces: `KhipuClientBundleHelper.podBundle` y `FontLoader.loadFonts()` resolviendo `Bundle.module` en SPM. Consumido por `Colors`, `RutField`, `CheckboxField`, `KhipuWebView`, `image(named:)`.

- [ ] **Step 1: `BundleHelper.swift` — `podBundle` condicional**

Reemplazar el cuerpo de la clase para que `podBundle` use `Bundle.module` en SPM:

```swift
import Foundation
import UIKit

public class KhipuClientBundleHelper {

    #if SWIFT_PACKAGE
    public static let podBundle: Bundle? = Bundle.module
    #else
    private static let podFramework = Bundle(for: KhipuClientBundleHelper.self)

    private static let podBundlePath = podFramework.path(
        forResource: "KhipuClientIOS",
        ofType: "bundle"
    )

    public static let podBundle: Bundle? = {
        guard let podBundlePath = podBundlePath else {
            return nil
        }
        return Bundle(path: podBundlePath)
    }()
    #endif

    public static func image(named imageName: String) -> UIImage? {
        guard let bundle = podBundle else {
            return nil
        }
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }
}
```

- [ ] **Step 2: `FontLoader.swift` — bundle condicional**

Reemplazar las 3 líneas de resolución del bundle (las que hacen `Bundle(for: FontLoader.self)` y buscan `KhipuClientIOS.bundle`) por:

```swift
        #if SWIFT_PACKAGE
        let resourceBundle: Bundle? = Bundle.module
        #else
        let bundle = Bundle(for: FontLoader.self)
        let resourceBundleURL = bundle.url(forResource: "KhipuClientIOS", withExtension: "bundle")
        let resourceBundle = resourceBundleURL != nil ? Bundle(url: resourceBundleURL!) : bundle
        #endif
```
(El resto de `loadFonts()` — el `fontNames.forEach` que usa `resourceBundle?.url(...)` — no cambia.)

- [ ] **Step 3: Commit**

```bash
git add KhipuClientIOS/Classes/SwiftUiClient/Util/BundleHelper.swift KhipuClientIOS/Classes/SwiftUiClient/Themes/FontLoader.swift
git commit -m "feat: resolver recursos vía Bundle.module en SPM (BundleHelper + FontLoader)"
```

---

### Task 3: `Package.swift` + bump de versión, y gate de build

**Files:**
- Create: `Package.swift`
- Modify: `KhipuClientIOS.podspec` (`s.version` → `2.16.3`)

**Interfaces:**
- Consumes: deps SPM (SocketIO, KhenshinProtocol, KhenshinSecureMessage); recursos en `Assets`.
- Produces: producto `.library("KhipuClientIOS")` + testTarget `KhipuClientIOSTests`.

- [ ] **Step 1: Crear `Package.swift`**

```swift
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KhipuClientIOS",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "KhipuClientIOS", targets: ["KhipuClientIOS"])
    ],
    dependencies: [
        .package(url: "https://github.com/socketio/socket.io-client-swift.git", from: "16.1.1"),
        .package(url: "https://github.com/khipu/KhenshinProtocolSwift.git", from: "1.0.60"),
        .package(url: "https://github.com/khipu/KhenshinSecureMessage.git", from: "1.4.1"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.10.3")
    ],
    targets: [
        .target(
            name: "KhipuClientIOS",
            dependencies: [
                .product(name: "SocketIO", package: "socket.io-client-swift"),
                .product(name: "KhenshinProtocol", package: "KhenshinProtocolSwift"),
                .product(name: "KhenshinSecureMessage", package: "KhenshinSecureMessage")
            ],
            path: "KhipuClientIOS",
            sources: ["Classes"],
            resources: [.process("Assets")]
        ),
        .testTarget(
            name: "KhipuClientIOSTests",
            dependencies: [
                "KhipuClientIOS",
                "ViewInspector",
                .product(name: "KhenshinProtocol", package: "KhenshinProtocolSwift")
            ],
            path: "Example/Tests",
            exclude: ["Info.plist"]
        )
    ]
)
```

- [ ] **Step 2: Bump del podspec**

En `KhipuClientIOS.podspec`: `s.version = '2.16.2'` → `s.version = '2.16.3'`. No cambiar las `s.dependency`.

- [ ] **Step 3: Resolver dependencias**

Run: `swift package resolve`
Expected: resuelve SocketIO, Starscream (transitiva), KhenshinProtocol 1.0.60, KhenshinSecureMessage 1.4.1, ViewInspector 0.10.3 sin errores. Si una versión no resuelve por toolchain, ajustar su piso `from:` y documentar.

- [ ] **Step 4: GATE — build del target para iOS (simulador)**

```bash
DEV=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone[^(]+\([0-9.]+\)' | head -1)
NAME=$(echo "$DEV" | sed -E 's/ \([0-9.]+\)$//' | sed 's/ *$//')
OS=$(echo "$DEV" | sed -E 's/.*\(([0-9.]+)\)$/\1/')
echo "Simulador: $NAME ($OS)"
xcodebuild build -scheme KhipuClientIOS -destination "platform=iOS Simulator,name=$NAME,OS=$OS" 2>&1 | tail -20
```
Expected: `** BUILD SUCCEEDED **`. (El target compila para iOS con SwiftUI/UIKit y resuelve los recursos.) Si falla por código de bundle, revisar Task 2.

- [ ] **Step 5: Commit**

```bash
git add Package.swift KhipuClientIOS.podspec
git commit -m "feat: Package.swift (deps + recursos) y bump 2.16.3"
```

---

### Task 4: GATE — tests ViewInspector en SPM (xcodebuild test)

**Files:** posiblemente `Assets/Images.xcassets/*` (contingencia de imágenes) — solo si el gate lo exige.

**Interfaces:**
- Consumes: testTarget `KhipuClientIOSTests`.
- Produces: evidencia de que la suite corre en SPM y de que los recursos (`Bundle.module`) se resuelven en runtime.

- [ ] **Step 1: Ejecutar la suite en simulador**

```bash
DEV=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone[^(]+\([0-9.]+\)' | head -1)
NAME=$(echo "$DEV" | sed -E 's/ \([0-9.]+\)$//' | sed 's/ *$//')
OS=$(echo "$DEV" | sed -E 's/.*\(([0-9.]+)\)$/\1/')
xcodebuild test -scheme KhipuClientIOS -destination "platform=iOS Simulator,name=$NAME,OS=$OS" 2>&1 | tail -40
```
Expected: `** TEST SUCCEEDED **` (o el resumen de XCTest con todos los tests en verde).

- [ ] **Step 2: Contingencia — imágenes PNG (solo si fallan tests de imágenes o `image(named:)` devuelve nil)**

Si la validación muestra que `logo-khipu-color`/`authorize` no cargan vía `UIImage(named:in:)` en SPM, crear `KhipuClientIOS/Assets/Images.xcassets` con dos imagesets (`logo-khipu-color`, `authorize`) que referencien los PNG existentes, y eliminar los PNG sueltos de `Assets/Images/`. El código no cambia (mismo nombre). Reejecutar el Step 1.

- [ ] **Step 3: Contingencia — tests que requieran host app**

Si tests concretos fallan por requerir host app (no por lógica), aislarlos con `@available`/`XCTSkip` documentando el motivo, o marcarlos. Registrar en el reporte cuáles y por qué. NO desactivar tests masivamente; solo los que genuinamente no corren sin host.

- [ ] **Step 4: Commit (solo si hubo contingencia)**

```bash
git add -A KhipuClientIOS/Assets Example/Tests
git commit -m "fix: ajustes para tests SPM (imágenes/host) "  # solo si aplica
```

> Si el gate no se puede pasar tras contingencias razonables, reportar `BLOCKED` con detalle: es señal de que la suite necesita decisión de diseño (p. ej. dividir tests SPM vs host).

---

### Task 5: Workflow de CI para SPM

**Files:**
- Create: `.github/workflows/spm.yml`

**Interfaces:**
- Produces: workflow `SPM Build & Test` (xcodebuild + simulador) en PRs y push a `master`.

- [ ] **Step 1: Crear el workflow**

```yaml
name: SPM Build & Test

on:
  push:
    branches: [master]
  pull_request:
  workflow_dispatch:

jobs:
  spm:
    name: xcodebuild (SPM)
    runs-on: macos-15
    steps:
      - uses: actions/checkout@v4
      - name: Select Xcode
        run: sudo xcode-select -s /Applications/Xcode_16.4.app
      - name: Find simulator
        id: sim
        run: |
          device=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone.*?[^\(]+ \(.+?\)' | head -1 | awk '{$1=$1;print}')
          echo "name=$(echo "$device" | sed -e 's/ Simulator.*//')" >> "$GITHUB_OUTPUT"
          echo "os=$(echo "$device" | sed -n 's/.*(\(.*\)).*/\1/p')" >> "$GITHUB_OUTPUT"
      - name: Build & Test (SPM)
        run: |
          xcodebuild test -scheme KhipuClientIOS \
            -destination "platform=iOS Simulator,OS=${{ steps.sim.outputs.os }},name=${{ steps.sim.outputs.name }}"
```

- [ ] **Step 2: Validar YAML**

Run: `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/spm.yml')); print('YAML OK')"`
Expected: `YAML OK`.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/spm.yml
git commit -m "ci: workflow SPM (xcodebuild + simulador iOS)"
```

---

### Task 6: Documentar el soporte SPM

**Files:** Modify: `README.md`

- [ ] **Step 1: Sección SPM en README**

Insertar bajo la instalación CocoaPods:

```markdown
## Installation (Swift Package Manager)

Add the package to your `Package.swift` dependencies:

    .package(url: "https://github.com/khipu/KhipuClientIOS.git", from: "2.16.3")

Then add `KhipuClientIOS` to your target's dependencies, or in Xcode use
**File → Add Package Dependencies…** with the same URL. Requires iOS 13+.
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: documentar instalación vía SPM"
```

---

### Task 7: Verificar CocoaPods intacto + consumidor SPM iOS

**Files:** Create (temporal, scratchpad): paquete consumidor iOS.

- [ ] **Step 1: Lint del pod**

Run: `pod lib lint --allow-warnings`
Expected: PASS — `KhipuClientIOS passed validation.`. (CocoaPods usa la rama `#else`; el bump a 2.16.3 no afecta el lint.) Si falla por red al traer pods dependientes, registrar; el gate definitivo es `deploy.yml` (Task 8).

- [ ] **Step 2: Consumidor SPM iOS (path local) — compila para iOS**

```bash
SCRATCH="/private/tmp/claude-501/-Users-edavis-git-KhipuClientIOS/f589e031-ced9-4f68-acc1-7ab642bef6e3/scratchpad"
rm -rf "$SCRATCH/KhipuConsumer"; mkdir -p "$SCRATCH/KhipuConsumer/Sources/KhipuConsumer"
cd "$SCRATCH/KhipuConsumer"
cat > Package.swift <<'PKG'
// swift-tools-version:5.5
import PackageDescription
let package = Package(
    name: "KhipuConsumer",
    platforms: [.iOS(.v13)],
    dependencies: [ .package(path: "/Users/edavis/git/KhipuClientIOS") ],
    targets: [ .target(name: "KhipuConsumer", dependencies: [
        .product(name: "KhipuClientIOS", package: "KhipuClientIOS") ]) ]
)
PKG
cat > Sources/KhipuConsumer/Consumer.swift <<'SWIFT'
import KhipuClientIOS
// Ejercita el acceso a recursos vía Bundle.module
public func smoke() { FontLoader.loadFonts() }
SWIFT
DEV=$(xcrun xctrace list devices 2>&1 | grep -oE 'iPhone[^(]+\([0-9.]+\)' | head -1)
NAME=$(echo "$DEV" | sed -E 's/ \([0-9.]+\)$//' | sed 's/ *$//'); OS=$(echo "$DEV" | sed -E 's/.*\(([0-9.]+)\)$/\1/')
xcodebuild build -scheme KhipuConsumer -destination "platform=iOS Simulator,name=$NAME,OS=$OS" 2>&1 | tail -8
cd ~ && rm -rf "$SCRATCH/KhipuConsumer"
```
Expected: `** BUILD SUCCEEDED **` — un consumidor externo resuelve e importa `KhipuClientIOS` y compila para iOS.

---

### Task 8: Release `2.16.3` (master → prod) — REQUIERE confirmación humana

**Files:** Ninguno nuevo (git + CI).

> **Operación sensible:** publica a CocoaPods trunk y crea el tag de versión. Confirmar con el usuario antes de los Steps 3-4.

- [ ] **Step 1: Push de `spm-migration` y PR a `master`**

```bash
cd ~/git/KhipuClientIOS
git push -u origin spm-migration
gh pr create --base master --head spm-migration \
  --title "Soporte SPM (dual con CocoaPods) — 2.16.3" \
  --body "Package.swift (deps SocketIO/KhenshinProtocol/KhenshinSecureMessage), recursos vía Bundle.module, testTarget ViewInspector (xcodebuild), workflow SPM, docs. Bump 2.16.3. Incluye specs/planes de la migración SPM completa."
```
Expected: `SPM Build & Test` y `Run Tests` corren en el PR y quedan verdes.

- [ ] **Step 2: Merge a `master`** (tras CI verde): `gh pr merge --merge`.

- [ ] **Step 3: Promover `master` → `prod`**

```bash
git checkout prod && git pull --ff-only origin prod
git merge --no-ff master -m "release: 2.16.3 con soporte SPM"
git push origin prod
```
Dispara `deploy.yml`: crea tag `2.16.3` (con `Package.swift`) + `pod trunk push`.

- [ ] **Step 4: Verificar deploy + tag**

```bash
gh run list --branch prod --limit 3
git fetch --tags origin && git ls-tree --name-only 2.16.3 | grep Package.swift && echo "Package.swift en tag 2.16.3 ✅"
```
Expected: `Deploy to Cocoapods` en `success`; el tag `2.16.3` contiene `Package.swift`.

- [ ] **Step 5: Validación final — consumidor remoto iOS**

Igual que Task 7 Step 2 pero con `.package(url: "https://github.com/khipu/KhipuClientIOS.git", .exact("2.16.3"))` y caché limpia (`rm -rf .build Package.resolved ~/Library/Caches/org.swift.swiftpm/repositories`). Expected: `** BUILD SUCCEEDED **`.

---

## Cierre

Al completar Task 8, `KhipuClientIOS 2.16.3` es consumible por SPM y CocoaPods, cerrando la migración completa del grafo (los 3 eslabones).

**Gate antes de cerrar:** `xcodebuild build` + `xcodebuild test` (ViewInspector), `pod lib lint`, consumidor remoto `2.16.3` — todos en verde.

## Self-Review

- **Cobertura del spec:** limpieza .DS_Store (Task 1) ✓; accessor Bundle.module BundleHelper+FontLoader (Task 2) ✓; Package.swift deps+recursos+platforms v13 + bump (Task 3) ✓; gate build iOS (Task 3) ✓; gate tests ViewInspector + contingencia imágenes/host (Task 4) ✓; spm.yml xcodebuild (Task 5) ✓; docs (Task 6) ✓; pod lib lint + consumidor iOS (Task 7) ✓; release master→prod (Task 8) ✓.
- **Placeholders:** sin TBD; código de Package.swift, BundleHelper, FontLoader y consumidores completo; comandos xcodebuild concretos con detección de simulador.
- **Consistencia:** producto/target `KhipuClientIOS`; `.product(name: "SocketIO", package: "socket.io-client-swift")`, `KhenshinProtocol`/`KhenshinSecureMessage` con sus packages; no se declara Starscream (transitiva); platforms v13 coherente en target y consumidores.
