import java.io.*;
import java.nio.file.*;
import java.util.*;

public class FileProcessor {

    private static boolean checkFirstLine(String line) {
        String tempLine = line.trim();
        return (tempLine.isEmpty() || tempLine.startsWith("/") || tempLine.startsWith("*")) && !tempLine.startsWith("#");
    }

    private static boolean checkForComment(String line) {
        return line.trim().startsWith("/") || line.trim().startsWith("*");
    }

    private static boolean checkForContent(String line) {
        return !line.trim().isEmpty() && !checkForComment(line) && !line.trim().startsWith("#");
    }

    private static boolean checkForParen(String line) {
        return line.trim().contains("(");
    }

    private static boolean checkForEndParen(String line) {
        return line.trim().endsWith(")");
    }

    private static boolean checkForFuncStart(String line) {
        return line.replace("\n", "").startsWith("{");
    }

    private static int processFile(String filename) throws IOException {
        List<String> lines = Files.readAllLines(Paths.get(filename));
        List<String> newLines = new ArrayList<>();
        int changeCounter = 0;
        int i = 0;
        while (i < lines.size()) {
            if (i < lines.size() - 3 && checkFirstLine(lines.get(i)) && checkForContent(lines.get(i + 1)) && checkForEndParen(lines.get(i + 2)) && checkForFuncStart(lines.get(i + 3))) {
                newLines.add(lines.get(i));
                newLines.add(lines.get(i + 1).trim() + " " + lines.get(i + 2).trim());
                newLines.add(lines.get(i + 3));
                i += 4;
                changeCounter++;
            } else if (i < lines.size() - 4 && checkFirstLine(lines.get(i)) && checkForContent(lines.get(i + 1)) && checkForParen(lines.get(i + 2)) && checkForEndParen(lines.get(i + 3)) && checkForFuncStart(lines.get(i + 4))) {
                newLines.add(lines.get(i));
                newLines.add(lines.get(i + 1).trim() + " " + lines.get(i + 2).trim());
                newLines.add(lines.get(i + 3));
                newLines.add(lines.get(i + 4));
                i += 5;
                changeCounter++;
            } else if (i < lines.size() - 5 && checkFirstLine(lines.get(i)) && checkForContent(lines.get(i + 1)) && checkForParen(lines.get(i + 2)) && checkForContent(lines.get(i + 3)) && checkForEndParen(lines.get(i + 4)) && checkForFuncStart(lines.get(i + 5))) {
                System.out.println("Found function with three lines of arguments, see: " + lines.get(i + 1) + lines.get(i + 2) + lines.get(i + 3) + lines.get(i + 4));
                newLines.add(lines.get(i));
                i++;
            } else {
                newLines.add(lines.get(i));
                i++;
            }
        }

        Files.write(Paths.get(filename), newLines);
        return changeCounter;
    }

    public static void main(String[] args) {
        String dirPath = "./"; // Current directory
        int totalChangeCount = 0;

        try (DirectoryStream<Path> stream = Files.newDirectoryStream(Paths.get(dirPath), "*.c")) {
            for (Path entry : stream) {
                System.out.println("Processing file: " + entry);
                int fileChangeCount = processFile(entry.toString());
                System.out.println("Done! Changes done: " + fileChangeCount);
                totalChangeCount += fileChangeCount;
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println("Done processing files! Total changes done: " + totalChangeCount);
    }
}
