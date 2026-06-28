# SPM para KhenshinSecureMessage (eslabón #2) — Diseño

**Fecha:** 2026-06-28
**Estado:** Decisiones confirmadas. Pendiente: plan + ejecución.
**Repo:** `khipu/KhenshinSecureMessage` (clonado en `~/git/KhenshinSecureMessage`).
**Contexto:** Segundo eslabón de la migración a SPM (ver `2026-06-28-spm-migration-design.md`). Depende de que la capa cripto (`tweetnacl-swiftwrap`) ya tenga SPM (✅ la tiene) y va antes de `KhipuClientIOS`.

## 1. Objetivo
Disponibilizar `KhenshinSecureMessage` vía SPM en paralelo a CocoaPods, validando que la criptografía es byte-compatible.

## 2. Estado actual (verificado)
- Código a mano: `KhenshinSecureMessage/Classes/SecureMessage.swift` (1 archivo). Usa `NaclBox.keyPair/before`, `NaclSecretBox.secretBox/open`.
- Dependencia cripto (CocoaPods): `KHTweetNaclSwift 1.1.0` (repo `khipu/TweetNaclSwift`, Swift+ObjC+C). `import KHTweetNaclSwift`.
- **Tests reales**: `Example/Tests/KhenshinSecureMessageSpec.swift` con **Quick + Nimble** (crea claves, ciclo encrypt/decrypt, múltiples mensajes, simétrico).
- Versión actual: `1.4.0`. Ramas: `main` (desarrollo) y `prod` (release).
- CI: `run-tests.yml` (push a `main`: build+test del Example vía CocoaPods) y `deploy.yml` (push a `prod`: crea el tag desde el podspec + `pod lib lint` + `pod trunk push`).

## 3. Hallazgo clave: historial con tweetnacl-swiftwrap
El commit `82bd04a` (oct 2025) migró **de** `KHTweetNacl` 1.1.4 (pod de `tweetnacl-swiftwrap`) **a** `KHTweetNaclSwift` 1.1.0 por *"compatibility issues"*. Evidencia de que el problema era de **CocoaPods/toolchain**, no de la cripto:
- `tweetnacl-swiftwrap` como pod (`KHTweetNacl`) usa un `module.map` manual de C (`preserve_paths`), frágil en CocoaPods.
- El commit previo `6c90704` peleaba con warnings del C/Swift del pod.
- El commit `82bd04a` también cambió la gestión de Xcode (`16.0` → `latest-stable`).

`tweetnacl-swiftwrap` está **diseñado para SPM** (Package.swift nativo, targets `CTweetNacl` + `TweetNacl`). Hipótesis: sus problemas como pod **no aplican en SPM**. **Confirmación empírica:** los tests Quick/Nimble de cripto son el gate — si pasan en SPM contra `TweetNacl`, queda demostrada la compatibilidad.

## 4. Decisiones
- **Cripto dual con import condicional** en `SecureMessage.swift`:
  ```swift
  #if SWIFT_PACKAGE
  import TweetNacl        // SPM: tweetnacl-swiftwrap
  #else
  import KHTweetNaclSwift // CocoaPods
  #endif
  ```
  CocoaPods no define `SWIFT_PACKAGE` → sigue usando exactamente `KHTweetNaclSwift` (sin cambio de comportamiento). Único cambio de código del eslabón.
- **`testTarget` SPM** con Quick + Nimble (hay tests reales). El `testTarget` aquí aporta valor real: valida la cripto contra `TweetNacl`.
- **Versionado: bump a `1.4.1`** (release normal, sin force-push). El repo maneja su versión libremente y este cambio modifica código.
- **Release vía flujo existente** `main` → `prod`: el `deploy.yml` crea el tag `1.4.1` (que ya incluirá `Package.swift`) y publica a trunk. SPM y CocoaPods quedan ambos en `1.4.1`.

## 5. `Package.swift` (sin mover archivos)

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
- `platforms` incluye `.macOS(.v10_15)` porque los tests (`swift test`) corren en macOS y Quick/Nimble lo requieren; el producto sigue soportando iOS 12.
- Versiones de Quick/Nimble: pisos `7.0.0`/`13.0.0`; si la resolución falla por toolchain, ajustar a las compatibles con Swift 6.3 (contingencia documentada en el plan).

## 6. Gate de validación
1. `swift build` (compila target + TweetNacl).
2. **`swift test` con los tests Quick/Nimble de cripto en verde** ← gate que confirma la compatibilidad de `tweetnacl-swiftwrap` (resuelve la duda de los "compatibility issues").
3. `pod lib lint --allow-warnings` sigue pasando (CocoaPods intacto; usa `#else`).
4. Consumidor SPM real desde el tag `1.4.1` tras el release.

## 7. Flujo de release
1. Rama `spm-support` desde `main`: `Package.swift`, import condicional, **bump podspec a `1.4.1`**, `spm.yml` (build+test), README.
2. Validación local (gate §6, puntos 1-3).
3. PR → `main`; `run-tests.yml` verde; merge a `main`.
4. Promover `main` → `prod` (push) → `deploy.yml` crea tag `1.4.1` (con `Package.swift`) + `pod trunk push`.
5. Validar consumidor SPM remoto desde `1.4.1` (gate §6, punto 4).

## 8. Riesgos
- **Compatibilidad cripto de `TweetNacl`**: mitigado por el gate de tests (§6.2). Si fallara, escalar a portar `KHTweetNaclSwift` a SPM (target mixto ObjC/C/Swift).
- **Resolución de Quick/Nimble** en la toolchain: contingencia de ajuste de versiones en el plan.
- **`run-tests.yml` en el PR**: el Example vía CocoaPods sigue usando `KHTweetNaclSwift` (rama `#else`), no debe romperse.
