<?php

function checkFirstLine($line) {
    $tempLine = trim($line);
    return ($tempLine === '' || strpos($tempLine, '/') === 0 || strpos($tempLine, '*') === 0) && strpos($tempLine, '#') !== 0;
}

function checkForComment($line) {
    return strpos(trim($line), '/') === 0 || strpos(trim($line), '*') === 0;
}

function checkForContent($line) {
    return trim($line) !== '' && !checkForComment($line) && strpos(trim($line), '#') !== 0;
}

function checkForParen($line) {
    return strpos(trim($line), '(') !== false;
}

function checkForEndParen($line) {
    return substr(trim($line), -1) === ')';
}

function checkForFuncStart($line) {
    return strpos(str_replace("\n", '', $line), '{') === 0;
}

function processFile($filename) {
    $lines = file($filename, FILE_IGNORE_NEW_LINES);
    $newLines = [];
    $changeCounter = 0;

    $i = 0;
    while ($i < count($lines)) {
        if ($i < count($lines) - 3 && checkFirstLine($lines[$i]) && checkForContent($lines[$i + 1]) && checkForEndParen($lines[$i + 2]) && checkForFuncStart($lines[$i + 3])) {
            array_push($newLines, $lines[$i]);
            array_push($newLines, trim($lines[$i + 1]) . ' ' . trim($lines[$i + 2]));
            array_push($newLines, $lines[$i + 3]);
            $i += 4;
            $changeCounter++;
        } else {
            array_push($newLines, $lines[$i]);
            $i++;
        }
    }

    file_put_contents($filename, implode("\n", $newLines));
    return $changeCounter;
}

$dirPath = './'; // Current directory
$totalChangeCount = 0;

foreach (new DirectoryIterator($dirPath) as $fileInfo) {
    if ($fileInfo->isDot()) continue;
    if ($fileInfo->getExtension() === 'c') {
        echo "Processing file: " . $fileInfo->getFilename() . "\n";
        $fileChangeCount = processFile($fileInfo->getPathname());
        echo "Done! Changes done: " . $fileChangeCount . "\n";
        $totalChangeCount += $fileChangeCount;
    }
}

echo "Done processing files! Total changes done: " . $totalChangeCount . "\n";
?>
