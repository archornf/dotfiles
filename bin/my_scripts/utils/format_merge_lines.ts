import * as fs from 'fs';
import * as path from 'path';

const checkFirstLine = (line: string): boolean => {
    const tempLine = line.trim();
    return (tempLine === '' || tempLine.startsWith('/') || tempLine.startsWith('*')) && !tempLine.startsWith('#');
};

const checkForComment = (line: string): boolean => {
    return line.trim().startsWith('/') || line.trim().startsWith("*");
};

const checkForContent = (line: string): boolean => {
    return line.trim() !== '' && !checkForComment(line) && !line.trim().startsWith('#');
};

const checkForParen = (line: string): boolean => {
    return line.trim().includes('(');
};

const checkForEndParen = (line: string): boolean => {
    return line.trim().endsWith(')');
};

const checkForFuncStart = (line: string): boolean => {
    return line.replace('\n', '').startsWith('{');
};

const processFile = (filename: string): number => {
    const lines = fs.readFileSync(filename, 'utf8').split('\n');
    let newLines: string[] = [];
    let changeCounter = 0;

    let i = 0;
    while (i < lines.length) {
        if (i < lines.length - 3 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForEndParen(lines[i+2]) && checkForFuncStart(lines[i+3])) {
            newLines.push(lines[i]);
            newLines.push(lines[i+1].trim() + ' ' + lines[i+2].trim());
            newLines.push(lines[i+3]);
            i += 4;
            changeCounter++;
        } else if (i < lines.length - 4 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForParen(lines[i+2]) && checkForEndParen(lines[i+3]) && checkForFuncStart(lines[i+4])) {
            newLines.push(lines[i]);
            newLines.push(lines[i+1].trim() + ' ' + lines[i+2].trim());
            newLines.push(lines[i+3]);
            newLines.push(lines[i+4]);
            i += 5;
            changeCounter++;
        } else if (i < lines.length - 5 && checkFirstLine(lines[i]) && checkForContent(lines[i+1]) && checkForParen(lines[i+2]) && checkForContent(lines[i+3]) && checkForEndParen(lines[i+4]) && checkForFuncStart(lines[i+5])) {
            console.log(`Found function with three lines of arguments, see: ${lines[i+1] + lines[i+2] + lines[i+3] + lines[i+4]}`);
            newLines.push(lines[i]);
            i++;
        } else {
            newLines.push(lines[i]);
            i++;
        }
    }

    fs.writeFileSync(filename, newLines.join('\n'));
    return changeCounter;
};

// Replace the path with the directory where your .c files are located
const dirPath = './'; // Current directory
let totalChangeCount = 0;
fs.readdirSync(dirPath).forEach(file => {
    if (path.extname(file) === '.c') {
        console.log(`Processing file: ${file}`);
        const fileChangeCount = processFile(path.join(dirPath, file));
        console.log(`Done! Changes done: ${fileChangeCount}`);
        totalChangeCount += fileChangeCount;
    }
});

console.log(`Done processing files! Total changes done: ${totalChangeCount}`);
