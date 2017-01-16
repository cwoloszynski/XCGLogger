import PackageDescription

let package = Package(
	name: "XCGLogger",
	targets: [
		Target(name: "XCGLogger"),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/polymorphic.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/core.git", majorVersion: 1),
    ]
)
