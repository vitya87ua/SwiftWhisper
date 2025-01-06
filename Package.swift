// swift-tools-version:5.5
import PackageDescription

var exclude: [String] = []

#if os(Linux)
// Linux doesn't support CoreML, and will attempt to import the coreml source directory
exclude.append("coreml")
#endif

let package = Package(
    name: "SwiftWhisper",
    platforms: [
        .macOS(.v12),
        .iOS(.v14),
        .watchOS(.v4),
        .tvOS(.v14)
    ],
    products: [.library(name: "SwiftWhisper", targets: ["SwiftWhisper"])],
    dependencies: [.package(
        url: "https://github.com/ggerganov/whisper.cpp.git",
        revision: "ebca09a3d1033417b0c630bbbe607b0f185b1488")
    ],
    targets: [
        .target(
            name: "SwiftWhisper",
            dependencies: [.product(name: "whisper", package: "whisper.cpp")],
            cSettings: [
                .define("GGML_USE_ACCELERATE", .when(platforms: [.macOS, .macCatalyst, .iOS])),
                .define("WHISPER_USE_COREML", .when(platforms: [.macOS, .macCatalyst, .iOS])),
                .define("WHISPER_COREML_ALLOW_FALLBACK", .when(platforms: [.macOS, .macCatalyst, .iOS]))
            ]
        )
    ]
    
)
