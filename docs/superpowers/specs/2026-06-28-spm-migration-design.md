# Migración a SPM del grafo Khipu iOS — Diseño

**Fecha:** 2026-06-28
**Estado:** Aprobado el plan maestro y el primer eslabón. Eslabones #2 y #3 tendrán su propio spec.
**Repos involucrados:** `KhipuClientIOS`, `KhenshinSecureMessage`, `KhenshinProtocolSwift`, `tweetnacl-swiftwrap` (+ `khenshin-websocket-schema` como generador, **no se modifica**).

## 1. Contexto y objetivo

`KhipuClientIOS` se distribuye hoy solo como CocoaPod. Ante el fin de ciclo de vida de CocoaPods, el objetivo es disponibilizarla también vía Swift Package Manager (SPM), **manteniendo CocoaPods en paralelo** durante la transición (modelo dual).

`KhipuClientIOS` no puede migrarse de forma aislada: arrastra un grafo de dependencias internas de Khipu que tampoco están en SPM. SPM resuelve dependencias únicamente vía SPM, por lo que la migración debe hacerse **de las hojas hacia la raíz**.

## 2. Grafo de dependencias y estado SPM

```
KhipuClientIOS  (objetivo final — sin SPM)
├── Socket.IO-Client-Swift 16.1.1   ✅ SPM oficial
├── Starscream 4.0.8                 ✅ SPM oficial
├── KhenshinProtocol 1.0.60          ❌ repo khipu/KhenshinProtocolSwift — sin Package.swift
└── KhenshinSecureMessage 1.4.0      ❌ sin Package.swift
    └── KHTweetNaclSwift 1.1.0        ❌ repo khipu/TweetNaclSwift (Swift+ObjC+C) — sin Package.swift
        └── (alternativa SPM ya lista) khipu/tweetnacl-swiftwrap → módulo TweetNacl ✅
```

**Hallazgo que acorta el camino:** existe `khipu/tweetnacl-swiftwrap` (pod `KHTweetNacl` 1.1.5) con `Package.swift` ya funcional (targets `CTweetNacl` + `TweetNacl`). Su módulo `TweetNacl` expone exactamente las clases que consume `KhenshinSecureMessage` (`NaclBox`, `NaclSecretBox`, `NaclUtil`, `NaclScalarMult`, `NaclSign`). Por tanto **no se porta** el complejo wrapper ObjC/C de `TweetNaclSwift`; en SPM se reutiliza `tweetnacl-swiftwrap`.

## 3. Plan maestro

### 3.1 Orden de migración (bottom-up)

| # | Repo | Pod | SPM hoy | Esfuerzo |
|---|------|-----|---------|----------|
| 0 | `tweetnacl-swiftwrap` | `KHTweetNacl` 1.1.5 | ✅ listo | 0 — se reutiliza como capa cripto |
| 1 | `KhenshinProtocolSwift` | `KhenshinProtocol` 1.0.60 | ❌ | Trivial (1 archivo, 0 deps) ← **primer eslabón** |
| 2 | `KhenshinSecureMessage` | `KhenshinSecureMessage` 1.4.0 | ❌ | Bajo (1 archivo + cambiar import → `TweetNacl`) |
| 3 | `KhipuClientIOS` | `KhipuClientIOS` 2.16.2 | ❌ | Alto (recursos + 4 deps + tests) |

`KhenshinProtocol` (1) y `KhenshinSecureMessage` (2) son independientes entre sí; ambos deben estar publicados con tag SPM **antes** de cerrar `KhipuClientIOS` (3). Cada repo se libera y valida antes de pasar al siguiente.

### 3.2 Convenciones comunes (template dual)

- Se conserva el `.podspec` intacto; se **agrega `Package.swift`** al lado.
- **No se mueven archivos.** El target SPM usa `path:` apuntando a la estructura actual (`<Repo>/Classes`); el testTarget a `Example/Tests`.
- `swift-tools-version: 5.5`, `platforms: [.iOS(.v12)]` (alineado con el deployment target actual y con `tweetnacl-swiftwrap`).
- **Mismo tag git** sirve a CocoaPods y SPM (SPM resuelve por tag git, sin registro externo).
- Se añade al CI un workflow de validación SPM, sin tocar el flujo de CocoaPods (`deploy.yml`).

### 3.3 Decisiones técnicas transversales

**(a) Capa cripto.** `KhenshinSecureMessage` seguirá dependiendo de `KHTweetNaclSwift` en su podspec, pero en SPM dependerá de `tweetnacl-swiftwrap` (módulo `TweetNacl`). Único cambio en código: import condicional.

```swift
#if SWIFT_PACKAGE
import TweetNacl
#else
import KHTweetNaclSwift
#endif
```

**(b) Recursos en `KhipuClientIOS`** (el reto técnico real, se detalla en su propio spec). Hoy el código busca un `.bundle` nombrado (patrón CocoaPods) en ≥6 sitios (`BundleHelper`, `FontLoader`, `Colors`, `RutField`, `CheckboxField`, `KhipuWebView`). Se unificará detrás de un único accessor que resuelva el bundle según el gestor (`Bundle.module` en SPM vs. bundle nombrado en CocoaPods), y en `Package.swift` los assets (`.ttf`, `.xcassets`, `.html`, `.png`) se declararán con `.process(...)`/`.copy(...)`.

**(c) Tests vía SPM.** Cada `Package.swift` declara `testTarget` apuntando a los tests existentes (sin moverlos). `ViewInspector` se agrega como dependencia SPM de test donde aplique. Riesgo conocido a validar en el eslabón #3: algunos tests de ViewInspector podrían requerir host app.

**(d) Versionado (regla por repo).**
- `KhenshinProtocol`: versión **sincronizada con el generador** `khenshin-websocket-schema` (auto-generado con quicktype). **No se hace bump artificial** por agregar SPM. Detalle en §4.
- `KhenshinSecureMessage` y `KhipuClientIOS`: manejan su propia versión normalmente.

**(e) CI.** Workflow nuevo de `swift build`/`swift test` (o `xcodebuild` con simulador iOS donde haya UIKit/SwiftUI) junto al flujo de pods existente.

## 4. Primer eslabón: `KhenshinProtocol` (`khipu/KhenshinProtocolSwift`)

### 4.1 Por qué primero
Caso más simple del grafo y plantilla para los siguientes: un único archivo Foundation puro (`KhenshinProtocol/Classes/KhenshinProtocol.swift`, modelos generados con quicktype), **sin dependencias internas y sin recursos**.

### 4.2 Estado actual (verificado)
- Rama `main`, pod `KhenshinProtocol` 1.0.60, publicado a CocoaPods trunk.
- Tag `1.0.60` apunta a un commit que **solo contiene el `.podspec`** (no `Package.swift`).
- `Example/Tests/Tests.swift` es solo el placeholder del template (`XCTAssert(true)`).
- CI: `run-tests.yml` (build+test del scheme Example vía pods) → `deploy.yml` (`pod lib lint` + `pod trunk push`).

### 4.3 Mecanismo de generación (hallazgo clave)
El generador `khenshin-websocket-schema` (Bitbucket Pipelines), en el paso *updating swift repository*:

```bash
git clone git@github.com:khipu/KhenshinProtocolSwift.git
rm -rf .../KhenshinProtocol/Classes/KhenshinProtocol.swift   # borra SOLO el .swift
quicktype -s schema -l swift *.json ... -o .../KhenshinProtocol.swift   # regenera SOLO el .swift
./update-swift-version.sh    # sed sobre s.version del .podspec
git add . && git commit && git tag $VERSION && git push
```

Implicaciones:
1. El pipeline **clona el repo Swift real y solo toca el `.swift` y `s.version`**. No recrea el repo desde plantilla → un `Package.swift` agregado al repo Swift **persiste** entre regeneraciones.
2. **No se modifica el generador.** El `Package.swift` no lleva versión adentro (la versión es el tag git), así que es estático y no necesita gestión del generador. Además, cualquier commit a `master` del generador correría `update-version.sh` y forzaría un bump a `1.0.61`, contradiciendo "mantener 1.0.60".
3. **Hacia adelante, gratis:** el próximo cambio de schema generará `1.0.61` heredando el `Package.swift` desde el clone, habilitando SPM de forma permanente sin más intervención.

### 4.4 Cambios concretos

**`Package.swift` (raíz del repo Swift, sin mover archivos):**

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
        ),
        .testTarget(
            name: "KhenshinProtocolTests",
            dependencies: ["KhenshinProtocol"],
            path: "Example/Tests",
            exclude: ["Info.plist"]
        )
    ]
)
```
- `path:` reutiliza la estructura actual → el `.podspec` queda intacto.
- Se excluye `Info.plist` del testTarget para evitar el warning de recurso sin manejar. (`.gitkeep` es archivo oculto y SPM lo ignora.)

**CI — `.github/workflows/spm.yml` (no toca el flujo de pods):**

```yaml
name: SPM Build & Test
on:
  push: { branches: [main] }
  pull_request:
  workflow_dispatch:
jobs:
  spm:
    runs-on: macos-15
    steps:
      - uses: actions/checkout@v4
      - run: sudo xcode-select -s /Applications/Xcode_16.4.app
      - run: swift build
      - run: swift test
```
Foundation puro → `swift build`/`swift test` en macOS basta para este eslabón. (En `KhipuClientIOS` se usará `xcodebuild` con simulador iOS.)

**Documentación:** nota en el README/CLAUDE.md del propio repo Swift indicando que el repo soporta SPM (no en el generador, para no gatillar el bump).

### 4.5 Estrategia de versión y tag (decisión: mover `1.0.60`)
Para que SPM funcione manteniendo `1.0.60` sin bump artificial:
1. Commit a `main` con `Package.swift` + `spm.yml`, con **`[skip ci]`** en el mensaje. Esto evita disparar `run-tests.yml` → `deploy.yml` → `pod trunk push` de `1.0.60` (que fallaría por estar ya publicada).
2. `git tag -f 1.0.60 <commit>` && `git push -f origin 1.0.60` (re-etiquetar al commit con el manifiesto).
3. Es seguro para CocoaPods: el `.swift` y el `.podspec` no cambian, el pod resultante es idéntico; los `source_files` (`KhenshinProtocol/Classes/**/*`) no incluyen el `Package.swift`.

### 4.6 Verificación (gate antes del eslabón #2)
1. `swift build` y `swift test` en verde, localmente y en CI.
2. `pod lib lint --allow-warnings` sigue pasando (CocoaPods intacto).
3. Tag `1.0.60` (movido) incluye `Package.swift`.
4. Prueba de consumidor real: proyecto iOS con `.package(url: "https://github.com/khipu/KhenshinProtocolSwift.git", from: "1.0.60")` que haga `import KhenshinProtocol` y compile.

### 4.7 Riesgos
- **Force-push de un tag publicado** (`1.0.60`): operación delicada, mitigada porque el contenido del pod no cambia. Consumidores CocoaPods con `1.0.60` re-resuelven al nuevo tag sin diferencia funcional.
- Olvidar `[skip ci]` en el commit → `deploy.yml` intentaría re-publicar `1.0.60` y quedaría en rojo (inocuo, pero ruidoso).

## 5. Eslabones siguientes (specs futuros)

- **#2 `KhenshinSecureMessage`:** `Package.swift` con dependencia a `tweetnacl-swiftwrap` (producto `TweetNacl`); import condicional en `SecureMessage.swift`; testTarget; versionado propio.
- **#3 `KhipuClientIOS`:** `Package.swift` con deps Socket.IO + Starscream + KhenshinProtocol + KhenshinSecureMessage; **manejo de recursos** (accessor unificado `Bundle.module`/bundle nombrado); migración de la suite de tests (ViewInspector) a testTarget SPM; CI con `xcodebuild`/simulador; versionado propio.

## 6. Decisiones registradas
- Alcance de esta sesión: plan maestro + primer eslabón (`KhenshinProtocol`).
- Modelo de distribución: **dual** CocoaPods + SPM (no cortar CocoaPods).
- Tests expuestos vía SPM (`testTarget`).
- Capa cripto en SPM: reutilizar `tweetnacl-swiftwrap` (no portar `TweetNaclSwift`).
- `KhenshinProtocol`: versión sincronizada con el generador; **mover el tag `1.0.60`** (sin bump); **no modificar** el generador.
