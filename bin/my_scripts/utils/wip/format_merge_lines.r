# R, is predominantly used for statistical computing and graphics, is
# less common since R is not typically used for file manipulation or text
# processing in the same way as scripting languages. However, R can handle
# basic file I/O and string manipulation, so it's possible to write a
# simplified version of the script in R.

checkFirstLine <- function(line) {
  tempLine <- trimws(line)
  return ((tempLine == '' || startsWith(tempLine, '/') || startsWith(tempLine, '*')) && !startsWith(tempLine, '#'))
}

checkForComment <- function(line) {
  return (startsWith(trimws(line), '/') || startsWith(trimws(line), '*'))
}

checkForContent <- function(line) {
  trimmed <- trimws(line)
  return (trimmed != '' && !checkForComment(trimmed) && !startsWith(trimmed, '#'))
}

checkForParen <- function(line) {
  return (grepl("\\(", trimws(line)))
}

checkForEndParen <- function(line) {
  return (grepl("\\)$", trimws(line)))
}

checkForFuncStart <- function(line) {
  return (startsWith(gsub("\n", "", line), '{'))
}

processFile <- function(filename) {
  lines <- readLines(filename, warn = FALSE)
  newLines <- c()
  changeCounter <- 0
  i <- 1

  while (i <= length(lines)) {
    if (i <= length(lines) - 3 && checkFirstLine(lines[i]) && checkForContent(lines[i + 1]) && checkForEndParen(lines[i + 2]) && checkForFuncStart(lines[i + 3])) {
      newLines <- c(newLines, lines[i], paste(trimws(lines[i + 1]), trimws(lines[i + 2])), lines[i + 3])
      i <- i + 4
      changeCounter <- changeCounter + 1
    } else {
      newLines <- c(newLines, lines[i])
      i <- i + 1
    }
  }

  writeLines(newLines, filename)
  return (changeCounter)
}

processDirectory <- function(dirPath) {
  files <- list.files(path = dirPath, pattern = "\\.c$", full.names = TRUE)
  totalChangeCount <- 0
  
  for (file in files) {
    cat("Processing file:", file, "\n")
    fileChangeCount <- processFile(file)
    cat("Done! Changes done:", fileChangeCount, "\n")
    totalChangeCount <- totalChangeCount + fileChangeCount
  }

  cat("Done processing files! Total changes done:", totalChangeCount, "\n")
}

# Replace the path with the directory where your .c files are located
dirPath <- "./" # Current directory
processDirectory(dirPath)
