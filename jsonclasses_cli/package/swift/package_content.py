def package_content() -> str:
    return """
import PackageDescription

let package = Package(
    name: "API",
    products: [
        .library(
            name: "API",
            targets: ["API"])
    ],
    dependencies: [
        .package(url: "https://github.com/fillmula/qsparser-swift.git", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "API",
            dependencies: ["QSParser"])
    ]
)
    """.strip() + '\n'
