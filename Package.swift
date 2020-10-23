// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Grid",
	platforms: [
		.iOS(.v13)
	],
    products: [
        .library( name: "Grid", targets: ["Grid"]),
    ],
    dependencies: [],
    targets: [
		.target(name: "Grid",dependencies: []),
    ]
)
