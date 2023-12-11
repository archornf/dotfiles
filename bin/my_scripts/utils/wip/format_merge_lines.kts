// Kotlin, being a statically-typed programming language that runs on the Java
// Virtual Machine, has capabilities similar to Java for handling file
// operations and string manipulation.

import java.io.File
import java.nio.file.Files
import java.nio.file.Paths

fun checkFirstLine(line: String): Boolean {
    val tempLine = line.trim()
    return (tempLine.isEmpty() || tempLine.startsWith('/') || tempLine.startsWith('*')) && !tempLine.startsWith('#')
}

fun checkForComment(line: String): Boolean {
    return line.trim().startsWith('/') || line.trim().startsWith("*")
}

fun checkForContent(line: String): Boolean {
    return line.trim().isNotEmpty() && !checkForComment(line) && !line.trim().startsWith('#')
}

fun checkForParen(line: String): Boolean {
    return line.trim().contains('(')
}

fun checkForEndParen(line: String): Boolean {
    return line.trim().endsWith(')')
}

fun checkForFuncStart(line: String): Boolean {
    return line.replace("\n", "").startsWith('{')
}

fun processFile(filename: String): Int {
    val lines = File(filename).readLines()
    val newLines = mutableListOf<String>()
    var changeCounter = 0
    var i = 0
    while (i < lines.size) {
        if (i < lines.size - 3 && checkFirstLine(lines[i]) && checkForContent(lines[i + 1]) && checkForEndParen(lines[i + 2]) && checkForFuncStart(lines[i + 3])) {
            newLines.add(lines[i])
            newLines.add("${lines[i + 1].trim()} ${lines[i + 2].trim()}")
            newLines.add(lines[i + 3])
            i += 4
            changeCounter++
        } else if (i < lines.size - 4 && checkFirstLine(lines[i]) && checkForContent(lines[i + 1]) && checkForParen(lines[i + 2]) && checkForEndParen(lines[i + 3]) && checkForFuncStart(lines[i + 4])) {
            newLines.add(lines[i])
            newLines.add("${lines[i + 1].trim()} ${lines[i + 2].trim()}")
            newLines.add(lines[i + 3])
            newLines.add(lines[i + 4])
            i += 5
            changeCounter++
        } else if (i < lines.size - 5 && checkFirstLine(lines[i]) && checkForContent(lines[i + 1]) && checkForParen(lines[i + 2]) && checkForContent(lines[i + 3]) && checkForEndParen(lines[i + 4]) && checkForFuncStart(lines[i + 5])) {
            println("Found function with three lines of arguments, see: ${lines[i + 1]} ${lines[i + 2]} ${lines[i + 3]} ${lines[i + 4]}")
            newLines.add(lines[i])
            i++
        } else {
            newLines.add(lines[i])
            i++
        }
    }

    File(filename).writeText(newLines.joinToString("\n"))
    return changeCounter
}

fun main() {
    val dirPath = "./" // Current directory
    var totalChangeCount = 0

    Files.newDirectoryStream(Paths.get(dirPath), "*.c").use { stream ->
        stream.forEach { path ->
            println("Processing file: ${path.fileName}")
            val fileChangeCount = processFile(path.toString())
            println("Done! Changes done: $fileChangeCount")
            totalChangeCount += fileChangeCount
        }
    }

    println("Done processing files! Total changes done: $totalChangeCount")
}
