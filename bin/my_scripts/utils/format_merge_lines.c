#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_LINE_LENGTH 1024

int checkFirstLine(const char *line) {
    while (isspace((unsigned char)*line)) line++;
    return (*line == '\0' || *line == '/' || *line == '*') && *line != '#';
}

int checkForComment(const char *line) {
    while (isspace((unsigned char)*line)) line++;
    return *line == '/' || *line == '*';
}

int checkForContent(const char *line) {
    while (isspace((unsigned char)*line)) line++;
    return *line != '\0' && !checkForComment(line) && *line != '#';
}

int checkForParen(const char *line) {
    return strchr(line, '(') != NULL;
}

int checkForEndParen(const char *line) {
    const char *ptr = line + strlen(line) - 1;
    while (ptr > line && isspace((unsigned char)*ptr)) ptr--;
    return *ptr == ')';
}

int checkForFuncStart(const char *line) {
    return line[0] == '{';
}

int processFile(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        perror("Error opening file");
        return 0;
    }

    char line[MAX_LINE_LENGTH];
    char nextLine[MAX_LINE_LENGTH];
    char tempLine[MAX_LINE_LENGTH];
    int changeCounter = 0;
    FILE *tempFile = tmpfile();

    while (fgets(line, sizeof(line), file)) {
        if (fgets(nextLine, sizeof(nextLine), file)) {
            strcpy(tempLine, line);
            if (checkFirstLine(tempLine) && checkForContent(nextLine)) {
                if (checkForEndParen(nextLine) && checkForFuncStart(fgets(tempLine, sizeof(tempLine), file))) {
                    fprintf(tempFile, "%s", line); // Write comment line
                    fprintf(tempFile, "%s ", nextLine); // Combine function signature
                    changeCounter++;
                } else {
                    fputs(line, tempFile); // Write original line
                    fputs(nextLine, tempFile); // Write next line
                }
            } else {
                fputs(line, tempFile); // Write original line
                ungetc('\n', file); // Push back the newline character to handle next line correctly
                fseek(file, -strlen(nextLine), SEEK_CUR); // Rewind the file pointer
            }
        } else {
            fputs(line, tempFile); // Write last line
            break;
        }
    }

    fclose(file);

    // Write the content of the temp file back to the original file
    file = fopen(filename, "w");
    if (!file) {
        perror("Error opening file");
        fclose(tempFile);
        return changeCounter;
    }

    rewind(tempFile);
    while (fgets(line, sizeof(line), tempFile)) {
        fputs(line, file);
    }

    fclose(file);
    fclose(tempFile);
    return changeCounter;
}

int main() {
    const char *filename = "example.c"; // Replace with your .c file
    printf("Processing file: %s\n", filename);
    int fileChangeCount = processFile(filename);
    printf("Done! Changes done: %d\n", fileChangeCount);

    return 0;
}
