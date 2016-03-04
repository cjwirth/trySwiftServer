import PackageDescription

let package = Package(
  name: "Hello",
  dependencies: [
    .Package(url: "https://github.com/kylef/Curassow.git", majorVersion: 0, minor: 4),
    .Package(url: "https://github.com/czechboy0/Jay.git", majorVersion: 0)
  ],
  exclude: ["XcodeProject", "Slides"]
)

