using System;
using System.IO;
using System.Collections.Generic;
using System.Text.RegularExpressions;

class Program
{
    static void Main()
    {
        string path = "./"; // Current directory
        int totalChangeCount = 0;

        foreach (string filename in Directory.GetFiles(path, "*.c"))
        {
            Console.WriteLine($"Processing file: {filename}");
            int fileChangeCount = ProcessFile(filename);
            Console.WriteLine($"Done! Changes done: {fileChangeCount}");
            totalChangeCount += fileChangeCount;
        }

        Console.WriteLine($"Done processing files! Total changes done: {totalChangeCount}");
    }

    static bool CheckFirstLine(string line)
    {
        string tempLine = line.Trim();
        return (tempLine == "" || tempLine.StartsWith('/') || tempLine.StartsWith('*')) && !tempLine.StartsWith('#');
    }

    static bool CheckForComment(string line)
    {
        return line.Trim().StartsWith('/') || line.Trim().StartsWith("*");
    }

    static bool CheckForContent(string line)
    {
        return line.Trim() != "" && !CheckForComment(line) && !line.Trim().StartsWith('#');
    }

    static bool CheckForParen(string line)
    {
        return line.Trim().Contains('(');
    }

    static bool CheckForEndParen(string line)
    {
        return line.Trim().EndsWith(')');
    }

    static bool CheckForFuncStart(string line)
    {
        return line.Replace("\n", "").StartsWith("{");
    }

    static string GetFunctionName(string line)
    {
        Match match = Regex.Match(line, @"\b(\w+)\s*\(");
        if (match.Success)
        {
            return match.Groups[1].Value;
        }
        else
        {
            return null;
        }
    }

    static int ProcessFile(string filename)
    {
        int changeCounter = 0;
        List<string> lines = new List<string>(File.ReadAllLines(filename));
        List<string> newLines = new List<string>();

        int i = 0;
        while (i < lines.Count)
        {
            if (i < lines.Count - 2 && CheckFirstLine(lines[i]) && CheckForEndParen(lines[i + 1]) && CheckForFuncStart(lines[i + 2]))
            {
                newLines.Add(lines[i]);
                string funcName = GetFunctionName(lines[i + 1]);
                string returnType = lines[i + 1].Split(new string[] { funcName }, StringSplitOptions.None)[0];
                newLines.Add(returnType.Trim());
                newLines.Add(lines[i + 1].Substring(returnType.Length));
                newLines.Add(lines[i + 2]);
                i += 3;
                changeCounter++;
            }
            else if (i < lines.Count - 3 && CheckFirstLine(lines[i]) && CheckForParen(lines[i + 1]) && CheckForEndParen(lines[i + 2]) && CheckForFuncStart(lines[i + 3]))
            {
                newLines.Add(lines[i]);
                string funcName = GetFunctionName(lines[i + 1]);
                string returnType = lines[i + 1].Split(new string[] { funcName }, StringSplitOptions.None)[0];
                newLines.Add(returnType.Trim());
                newLines.Add(lines[i + 1].Substring(returnType.Length));
                newLines.Add(lines[i + 2]);
                newLines.Add(lines[i + 3]);
                i += 4;
                changeCounter++;
            }
            else if (i < lines.Count - 4 && CheckFirstLine(lines[i]) && !CheckForComment(lines[i + 1]) && CheckForParen(lines[i + 1]) && !CheckForComment(lines[i + 2]) && CheckForContent(lines[i + 2]) && CheckForEndParen(lines[i + 3]) && CheckForFuncStart(lines[i + 4]))
            {
                Console.WriteLine($"Found function with three lines of arguments, see: {lines[i + 1] + lines[i + 2] + lines[i + 3] + lines[i + 4]}");
                newLines.Add(lines[i]);
                i++;
            }
            else
            {
                newLines.Add(lines[i]);
                i++;
            }
        }

        File.WriteAllLines(filename, newLines);
        return changeCounter;
    }
}
