package main

import (
    "bufio"
    "fmt"
    "os"
    "path/filepath"
    "strings"
)

func checkFirstLine(line string) bool {
    tempLine := strings.TrimSpace(line)
    return (tempLine == "" || strings.HasPrefix(tempLine, "/") || strings.HasPrefix(tempLine, "*")) && !strings.HasPrefix(tempLine, "#")
}

func checkForComment(line string) bool {
    return strings.HasPrefix(strings.TrimSpace(line), "/") || strings.HasPrefix(strings.TrimSpace(line), "*")
}

func checkForContent(line string) bool {
    return strings.TrimSpace(line) != "" && !checkForComment(line) && !strings.HasPrefix(strings.TrimSpace(line), "#")
}

func checkForParen(line string) bool {
    return strings.Contains(strings.TrimSpace(line), "(")
}

func checkForEndParen(line string) bool {
    return strings.HasSuffix(strings.TrimSpace(line), ")")
}

func checkForFuncStart(line string) bool {
    return strings.HasPrefix(strings.Replace(line, "\n", "", -1), "{")
}

func processFile(filename string) int {
    file, err := os.Open(filename)
    if err != nil {
        fmt.Println("Error opening file:", err)
        return 0
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    var lines []string
    for scanner.Scan() {
        lines = append(lines, scanner.Text())
    }

    var newLines []string
    changeCounter := 0
    i := 0
    for i < len(lines) {
        if i < len(lines)-3 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForEndParen(lines[i+2]) && checkForFuncStart(lines[i+3]) {
            newLines = append(newLines, lines[i])
            newLines = append(newLines, lines[i+1] + " " + lines[i+2])
            newLines = append(newLines, lines[i+3])
            i += 4
            changeCounter++
        } else if i < len(lines)-4 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForParen(lines[i+2]) && checkForEndParen(lines[i+3]) && checkForFuncStart(lines[i+4]) {
            newLines = append(newLines, lines[i])
            newLines = append(newLines, lines[i+1] + " " + lines[i+2])
            newLines = append(newLines, lines[i+3])
            newLines = append(newLines, lines[i+4])
            i += 5
            changeCounter++
        } else if i < len(lines)-5 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForParen(lines[i+2]) && checkForContent(lines[i+3]) && checkForEndParen(lines[i+4]) && checkForFuncStart(lines[i+5]) {
            fmt.Printf("Found function with three lines of arguments, see: %s\n", lines[i+1]+lines[i+2]+lines[i+3]+lines[i+4])
            newLines = append(newLines, lines[i])
            i++
        } else {
            newLines = append(newLines, lines[i])
            i++
        }
    }

    // Write the processed lines back to the file
    file, err = os.Create(filename)
    if err != nil {
        fmt.Println("Error creating file:", err)
        return changeCounter
    }
    defer file.Close()
    writer := bufio.NewWriter(file)
    for _, line := range newLines {
        fmt.Fprintln(writer, line)
    }
    writer.Flush()
    return changeCounter
}

func main() {
    path := "./" // Current directory
    totalChangeCount := 0
    err := filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
        if err != nil {
            fmt.Println("Error walking the path:", err)
            return err
        }
        if strings.HasSuffix(path, ".c") {
            fmt.Println("Processing file:", path)
            fileChangeCount := processFile(path)
            fmt.Println("Done! Changes done:", fileChangeCount)
            totalChangeCount += fileChangeCount
        }
        return nil
    })

    if err != nil {
        fmt.Println("Error walking the directory:", err)
    }

    fmt.Println("Done processing files! Total changes done:", totalChangeCount)
}
