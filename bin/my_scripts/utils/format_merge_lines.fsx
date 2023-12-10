// F# is a functional-first programming language that runs on the .NET
// platform. It is well-suited for tasks involving file operations and string
// manipulation.

open System
open System.IO

let checkFirstLine (line: string) =
    let tempLine = line.Trim()
    (tempLine = "" || tempLine.StartsWith("/") || tempLine.StartsWith("*")) && not (tempLine.StartsWith("#"))

let checkForComment (line: string) =
    let trimmedLine = line.Trim()
    trimmedLine.StartsWith("/") || trimmedLine.StartsWith("*")

let checkForContent (line: string) =
    let trimmedLine = line.Trim()
    trimmedLine <> "" && not (checkForComment trimmedLine) && not (trimmedLine.StartsWith("#"))

let checkForParen (line: string) =
    line.Contains("(")

let checkForEndParen (line: string) =
    line.Trim().EndsWith(")")

let checkForFuncStart (line: string) =
    line.Replace("\n", "").StartsWith("{")

let processFile (filename: string) =
    let lines = File.ReadAllLines(filename)
    let mutable newLines = []
    let mutable changeCounter = 0
    let mutable i = 0

    while i < lines.Length do
        if i < lines.Length - 3 && checkFirstLine(lines.[i]) && checkForContent(lines.[i + 1]) && checkForEndParen(lines.[i + 2]) && checkForFuncStart(lines.[i + 3]) then
            newLines.Add(lines.[i])
            newLines.Add(sprintf "%s %s" (lines.[i + 1].Trim()) (lines.[i + 2].Trim()))
            newLines.Add(lines.[i + 3])
            i <- i + 4
            changeCounter <- changeCounter + 1
        else
            newLines.Add(lines.[i])
            i <- i + 1

    File.WriteAllLines(filename, newLines |> Seq.toArray)
    changeCounter

[<EntryPoint>]
let main argv =
    let dirPath = "./" // Current directory
    let mutable totalChangeCount = 0

    Directory.GetFiles(dirPath, "*.c")
    |> Array.iter (fun filename ->
        printfn "Processing file: %s" filename
        let fileChangeCount = processFile filename
        printfn "Done! Changes done: %d" fileChangeCount
        totalChangeCount <- totalChangeCount + fileChangeCount
    )

    printfn "Done processing files! Total changes done: %d" totalChangeCount
    0 // Return an integer exit code
