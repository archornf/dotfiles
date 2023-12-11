// Swift, known for its use in iOS and macOS application development, is also
// capable of scripting and handling file operations and string manipulation.

import Foundation

func checkFirstLine(_ line: String) -> Bool {
    let tempLine = line.trimmingCharacters(in: .whitespaces)
    return (tempLine.isEmpty || tempLine.hasPrefix("/") || tempLine.hasPrefix("*")) && !tempLine.hasPrefix("#")
}

func checkForComment(_ line: String) -> Bool {
    let trimmedLine = line.trimmingCharacters(in: .whitespaces)
    return trimmedLine.hasPrefix("/") || trimmedLine.hasPrefix("*")
}

func checkForContent(_ line: String) -> Bool {
    let trimmedLine = line.trimmingCharacters(in: .whitespaces)
    return !trimmedLine.isEmpty && !checkForComment(trimmedLine) && !trimmedLine.hasPrefix("#")
}

func checkForParen(_ line: String) -> Bool {
    return line.contains("(")
}

func checkForEndParen(_ line: String) -> Bool {
    return line.trimmingCharacters(in: .whitespaces).hasSuffix(")")
}

func checkForFuncStart(_ line: String) -> Bool {
    return line.replacingOccurrences(of: "\n", with: "").hasPrefix("{")
}

func processFile(_ filename: String) -> Int {
    do {
        let fileContents = try String(contentsOfFile: filename, encoding: .utf8)
        let lines = fileContents.components(separatedBy: "\n")
        var newLines = [String]()
        var changeCounter = 0
        var i = 0

        while i < lines.count {
            if i < lines.count - 3 && checkFirstLine(lines[i]) && checkForContent(lines[i + 1]) && checkForEndParen(lines[i + 2]) && checkForFuncStart(lines[i + 3]) {
                newLines.append(lines[i])
                newLines.append("\(lines[i + 1].trimmingCharacters(in: .whitespaces)) \(lines[i + 2].trimmingCharacters(in: .whitespaces))")
                newLines.append(lines[i + 3])
                i += 4
                changeCounter += 1
            } else {
                newLines.append(lines[i])
                i += 1
            }
        }

        try newLines.joined(separator: "\n").write(toFile: filename, atomically: true, encoding: .utf8)
        return changeCounter
    } catch {
        print("An error occurred: \(error)")
        return 0
    }
}

let fileManager = FileManager.default
let dirPath = "./" // Current directory

do {
    let items = try fileManager.contentsOfDirectory(atPath: dirPath)
    var totalChangeCount = 0

    for item in items {
        if item.hasSuffix(".c") {
            print("Processing file: \(item)")
            let fileChangeCount = processFile("\(dirPath)/\(item)")
            print("Done! Changes done: \(fileChangeCount)")
            totalChangeCount += fileChangeCount
        }
    }

    print("Done processing files! Total changes done: \(totalChangeCount)")
} catch {
    print("Failed to read contents of the directory: \(error)")
}
