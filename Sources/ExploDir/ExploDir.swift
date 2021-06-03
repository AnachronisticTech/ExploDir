import ArgumentParser
import Foundation

@main
struct ExploDir: ParsableCommand {
    @Argument(help: "Directory path to explode")
    var path: String

    @Flag(name: .short, help: "Delete the exploded directory")
    var delete: Bool = false

    func run() throws {
        let expandedPath = (path as NSString).expandingTildeInPath as String
        guard FileManager.default.directoryExists(expandedPath) else { return }

        let parentDirectory = expandedPath
            .split(separator: "/")
            .dropLast()
            .joined(separator: "/")

        guard let directoryContents = try? FileManager.default.contentsOfDirectory(atPath: expandedPath) else { return }

        for item in directoryContents {
            try? FileManager.default.moveItem(
                atPath: "\(expandedPath)/\(item)", 
                toPath: "/\(parentDirectory)/\(item)"
            )
        }

        guard
            let directoryContents = try? FileManager.default.contentsOfDirectory(atPath: expandedPath),
            directoryContents.isEmpty
        else { return }

        guard delete else { return }
        try? FileManager.default.removeItem(atPath: expandedPath)
    }
}

extension FileManager {
    func directoryExists(_ atPath: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: atPath, isDirectory:&isDirectory)
        return exists && isDirectory.boolValue
    }
}
