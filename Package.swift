// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "KhipuClientIOS",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "KhipuClientIOS", targets: ["KhipuClientIOS"])
    ],
    dependencies: [
        // Fijadas exacto para calzar con KhipuClientIOS.podspec: un consumidor por
        // CocoaPods y otro por SPM del mismo tag deben resolver el mismo grafo.
        // `.exact` en vez de `exact:` porque swift-tools-version es 5.5.
        .package(url: "https://github.com/socketio/socket.io-client-swift.git", .exact("16.1.1")),
        // Transitiva de SocketIO, declarada acá solo para fijarla. El manifiesto de
        // socket.io-client-swift la pide `.upToNextMajor(from: "4.0.8")`, así que sin esta
        // línea puede resolver cualquier 4.x por SPM mientras el podspec la clava en 4.0.8.
        .package(url: "https://github.com/daltoniam/Starscream", .exact("4.0.8")),
        .package(url: "https://github.com/khipu/KhenshinProtocolSwift.git", .exact("1.0.60")),
        .package(url: "https://github.com/khipu/KhenshinSecureMessage.git", .exact("1.4.1")),
        // Solo para tests, no llega al consumidor.
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
