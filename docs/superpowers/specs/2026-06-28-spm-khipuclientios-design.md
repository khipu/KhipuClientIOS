# SPM para KhipuClientIOS (eslabón #3 — objetivo final) — Diseño

**Fecha:** 2026-06-28
**Estado:** Decisiones confirmadas. Pendiente: plan + ejecución.
**Repo:** `khipu/KhipuClientIOS` (este repo). Implementación en la rama `spm-migration`.
**Contexto:** Eslabón final. Depende de #1 (`KhenshinProtocol 1.0.60` ✅) y #2 (`KhenshinSecureMessage 1.4.1` ✅), ambos ya en SPM.

## 1. Objetivo
Disponibilizar `KhipuClientIOS` vía SPM (dual con CocoaPods), versión `2.16.3`, con los recursos resueltos vía `Bundle.module` y la suite ViewInspector corriendo en SPM.

## 2. Estado actual (verificado)
- ~150 archivos Swift en `KhipuClientIOS/Classes` (SwiftUI: 83 imports; UIKit: 11; WebKit, CoreLocation, Vision, etc.).
- Dependencias (CocoaPods): `Socket.IO-Client-Swift 16.1.1`, `Starscream 4.0.8`, `KhenshinProtocol`, `KhenshinSecureMessage`.
- Recursos en `KhipuClientIOS/Assets`: `Colors.xcassets` (~30 colorsets), 4 fuentes `.ttf`, `khipuClient.html`, 2 PNG (`logo-khipu-color`, `authorize`).
- Acceso a recursos: centralizado en `KhipuClientBundleHelper.podBundle` (usado por `Colors`, `RutField`, `CheckboxField`, `KhipuWebView`, `image(named:)`); `FontLoader` usa su propio `Bundle(for:)`. Patrón CocoaPods (bundle nombrado).
- Tests: `Example/Tests` (~52 archivos, Quick no; **ViewInspector 0.10.3** + XCTest). Importan `ViewInspector`, `KhenshinProtocol` (25), `KhipuClientIOS`.
- Versión: `2.16.2`. Ramas `master` (run-tests) y `prod` (deploy → tag + `pod trunk push`).

## 3. Decisiones confirmadas
- **Dependencias SPM directas (3)**: `SocketIO`, `KhenshinProtocol 1.0.60`, `KhenshinSecureMessage 1.4.1`. **Starscream NO se declara** (transitiva de SocketIO; el código no la importa).
- **platforms: `[.iOS(.v13)]`** (realidad SwiftUI; alineado con el Example Podfile).
- **testTarget completo** con ViewInspector, validado con `xcodebuild test` en simulador iOS.
- **Versionado: bump a `2.16.3`**, release vía `master` → `prod`.

## 4. Hallazgo crítico: paquete iOS-only
El código importa `UIKit`/`SwiftUI`/`WebKit`/`CoreLocation`/`Vision` (no existen en macOS). Por tanto **`swift build`/`swift test` en macOS fallan**; build, tests y validación usan **`xcodebuild` + simulador iOS** (igual que el `run-tests.yml` actual del Example). Esto distingue al #3 de #1/#2.

## 5. Manejo de recursos (reto técnico)
Se centraliza el cambio en dos archivos, con compilación condicional:

**`KhipuClientBundleHelper`** (`SwiftUiClient/Util/BundleHelper.swift`):
```swift
public class KhipuClientBundleHelper {
    #if SWIFT_PACKAGE
    public static let podBundle: Bundle? = Bundle.module
    #else
    private static let podFramework = Bundle(for: KhipuClientBundleHelper.self)
    private static let podBundlePath = podFramework.path(forResource: "KhipuClientIOS", ofType: "bundle")
    public static let podBundle: Bundle? = {
        guard let podBundlePath = podBundlePath else { return nil }
        return Bundle(path: podBundlePath)
    }()
    #endif

    public static func image(named imageName: String) -> UIImage? {
        guard let bundle = podBundle else { return nil }
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }
}
```
`Colors`, `RutField`, `CheckboxField`, `KhipuWebView` usan `podBundle` → quedan cubiertos sin cambios.

**`FontLoader`** (`SwiftUiClient/Themes/FontLoader.swift`): reemplazar su resolución por `#if SWIFT_PACKAGE` → `Bundle.module`, `#else` → el `Bundle(for:)` actual.

**`Package.swift`** (sin mover archivos): `path: "KhipuClientIOS"`, `sources: ["Classes"]`, `resources: [.process("Assets")]`.

**Limpieza:** eliminar los `.DS_Store` trackeados bajo `Assets/` (estorban a `.process`).

**Riesgo — imágenes PNG sueltas:** `logo-khipu-color.png` y `authorize.png` se cargan con `UIImage(named:in:)`. En SPM con `.process`, `UIImage(named:)` puede no resolver PNG sueltos. **Plan de contingencia:** si la validación falla, mover ambas a un `Images.xcassets` (imageset) dentro de `Assets/` — los acceden por el mismo nombre, sin cambio de código.

## 6. `Package.swift`

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

## 7. CI (`spm.yml`)
Modelado sobre `run-tests.yml`: detecta un simulador iPhone y corre `xcodebuild test -scheme KhipuClientIOS -destination 'platform=iOS Simulator,...'`. No interfiere con `run-tests.yml` (master) ni `deploy.yml` (prod).

## 8. Gate de validación
1. `xcodebuild build -scheme KhipuClientIOS -destination 'generic/platform=iOS Simulator'` (compila target + deps + recursos).
2. **`xcodebuild test` con la suite ViewInspector en simulador iOS** ← valida también el manejo de recursos (`Bundle.module`) en runtime. Riesgo: tests que requieran host app o las imágenes PNG; ajustar según §5.
3. `pod lib lint --allow-warnings` (CocoaPods intacto; usa la rama `#else`).
4. Consumidor SPM iOS real desde el tag `2.16.3` tras el release.

## 9. Flujo de release
1. Implementación en rama `spm-migration` (este repo): `Package.swift`, accessor de bundle, `FontLoader`, bump podspec `2.16.3`, `spm.yml`, README, limpieza `.DS_Store`.
2. Validación local (gate §8.1-8.3).
3. PR `spm-migration` → `master`; `run-tests.yml` + `spm.yml` verdes; merge.
4. Promover `master` → `prod` → `deploy.yml` (tag `2.16.3` con `Package.swift` + `pod trunk push`).
5. Validar consumidor SPM remoto desde `2.16.3`.

## 10. Riesgos
- **Imágenes PNG en SPM** (§5): contingencia = mover a `.xcassets`.
- **Tests ViewInspector iOS-only**: algunos podrían requerir host app; ajustar o aislar los que fallen, documentándolo.
- **Resolución de deps** (SocketIO/ViewInspector versiones) en la toolchain: ajustar pisos si la resolución falla.
- **`run-tests.yml` en el PR**: el Example vía CocoaPods sigue usando el bundle nombrado (rama `#else`), no debe romperse.
