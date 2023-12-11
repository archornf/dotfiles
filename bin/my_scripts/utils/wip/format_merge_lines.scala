// Scala, being a functional and object-oriented programming language that runs
// on the Java Virtual Machine, is well-suited for tasks involving file
// operations and string manipulation.

import java.nio.file.{Files, Paths, Path}
import scala.collection.JavaConverters._

object FileProcessor extends App {
  def checkFirstLine(line: String): Boolean = {
    val tempLine = line.trim
    (tempLine.isEmpty || tempLine.startsWith("/") || tempLine.startsWith("*")) && !tempLine.startsWith("#")
  }

  def checkForComment(line: String): Boolean = {
    line.trim.startsWith("/") || line.trim.startsWith("*")
  }

  def checkForContent(line: String): Boolean = {
    line.trim.nonEmpty && !checkForComment(line) && !line.trim.startsWith("#")
  }

  def checkForParen(line: String): Boolean = {
    line.trim.contains("(")
  }

  def checkForEndParen(line: String): Boolean = {
    line.trim.endsWith(")")
  }

  def checkForFuncStart(line: String): Boolean = {
    line.replace("\n", "").startsWith("{")
  }

  def processFile(path: Path): Int = {
    val lines = Files.readAllLines(path).asScala
    val newLines = scala.collection.mutable.ArrayBuffer[String]()
    var changeCounter = 0
    var i = 0

    while (i < lines.length) {
      if (i < lines.length - 3 && checkFirstLine(lines(i)) && checkForContent(lines(i + 1)) && checkForEndParen(lines(i + 2)) && checkForFuncStart(lines(i + 3))) {
        newLines += lines(i)
        newLines += lines(i + 1).trim + " " + lines(i + 2).trim
        newLines += lines(i + 3)
        i += 4
        changeCounter += 1
      } else {
        newLines += lines(i)
        i += 1
      }
    }

    Files.write(path, newLines.asJava)
    changeCounter
  }

  val dirPath = "./" // Current directory
  var totalChangeCount = 0

  Files.newDirectoryStream(Paths.get(dirPath), "*.c").asScala.foreach { path =>
    println(s"Processing file: ${path.getFileName}")
    val fileChangeCount = processFile(path)
    println(s"Done! Changes done: $fileChangeCount")
    totalChangeCount += fileChangeCount
  }

  println(s"Done processing files! Total changes done: $totalChangeCount")
}
