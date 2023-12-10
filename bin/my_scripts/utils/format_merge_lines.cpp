#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <algorithm>
#include <filesystem>
namespace fs = std::filesystem;

bool checkFirstLine(const std::string& line) {
    std::string tempLine = line;
    tempLine.erase(std::remove_if(tempLine.begin(), tempLine.end(), isspace), tempLine.end());
    return (tempLine.empty() || tempLine[0] == '/' || tempLine[0] == '*') && tempLine[0] != '#';
}

bool checkForComment(const std::string& line) {
    std::string tempLine = line;
    tempLine.erase(std::remove_if(tempLine.begin(), tempLine.end(), isspace), tempLine.end());
    return tempLine[0] == '/' || tempLine[0] == '*';
}

bool checkForContent(const std::string& line) {
    std::string tempLine = line;
    tempLine.erase(std::remove_if(tempLine.begin(), tempLine.end(), isspace), tempLine.end());
    return !tempLine.empty() && !checkForComment(tempLine) && tempLine[0] != '#';
}

bool checkForParen(const std::string& line) {
    return line.find('(') != std::string::npos;
}

bool checkForEndParen(const std::string& line) {
    return line.find(')') != std::string::npos && line.find(')') == line.size() - 1;
}

bool checkForFuncStart(const std::string& line) {
    return line.find('{') != std::string::npos && line.find('{') == 0;
}

int processFile(const std::string& filename) {
    std::ifstream file(filename);
    std::vector<std::string> lines;
    std::string line;
    while (std::getline(file, line)) {
        lines.push_back(line);
    }
    file.close();

    std::vector<std::string> newLines;
    int changeCounter = 0;
    size_t i = 0;
    while (i < lines.size()) {
        if (i < lines.size() - 3 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForEndParen(lines[i+2]) && checkForFuncStart(lines[i+3])) {
            newLines.push_back(lines[i]);
            newLines.push_back(lines[i+1] + " " + lines[i+2]);
            newLines.push_back(lines[i+3]);
            i += 4;
            changeCounter++;
        } else if (i < lines.size() - 4 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForParen(lines[i+2]) && checkForEndParen(lines[i+3]) && checkForFuncStart(lines[i+4])) {
            newLines.push_back(lines[i]);
            newLines.push_back(lines[i+1] + " " + lines[i+2]);
            newLines.push_back(lines[i+3]);
            newLines.push_back(lines[i+4]);
            i += 5;
            changeCounter++;
        } else if (i < lines.size() - 5 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForParen(lines[i+2]) && checkForContent(lines[i+3]) && checkForEndParen(lines[i+4]) && checkForFuncStart(lines[i+5])) {
            std::cout << "Found function with three lines of arguments, see: " << lines[i+1] << " " << lines[i+2] << " " << lines[i+3] << " " << lines[i+4] << std::endl;
            newLines.push_back(lines[i]);
            i++;
        } else {
            newLines.push_back(lines[i]);
            i++;
        }
    }

    std::ofstream outFile(filename);
    for (const auto& newLine : newLines) {
        outFile << newLine << "\n";
    }
    outFile.close();

    return changeCounter;
}

int main() {
    std::string path = "./"; // Current directory
    int totalChangeCount = 0;
    for (const auto& entry : fs::directory_iterator(path)) {
        if (entry.path().extension() == ".c") {
            std::cout << "Processing file: " << entry.path() << std::endl;
            int fileChangeCount = processFile(entry.path());
            std::cout << "Done! Changes done: " << fileChangeCount << std::endl;
            totalChangeCount += fileChangeCount;
        }
    }

    std::cout << "Done processing files! Total changes done: " << totalChangeCount << std::endl;
    return 0;
}
