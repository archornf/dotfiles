// Haskell, a purely functional programming language, involves a different
// approach due to Haskell's emphasis on immutability and function purity. Here's
// how you can write a similar script in Haskell:

import System.Directory
import System.FilePath
import Control.Monad
import Data.List

checkFirstLine :: String -> Bool
checkFirstLine line =
    let tempLine = dropWhile (== ' ') line
    in (null tempLine || head tempLine == '/' || head tempLine == '*') && not (head tempLine == '#')

checkForComment :: String -> Bool
checkForComment line =
    let trimmedLine = dropWhile (== ' ') line
    in head trimmedLine == '/' || head trimmedLine == '*'

checkForContent :: String -> Bool
checkForContent line =
    let trimmedLine = dropWhile (== ' ') line
    in not (null trimmedLine) && not (checkForComment line) && not (head trimmedLine == '#')

checkForParen :: String -> Bool
checkForParen line = '(' `elem` line

checkForEndParen :: String -> Bool
checkForEndParen line = ')' `elem` (reverse $ dropWhile (== ' ') line)

checkForFuncStart :: String -> Bool
checkForFuncStart line = head (filter (not . (`elem` " \n")) line) == '{'

processLine :: [String] -> [String]
processLine (a:b:c:d:rest)
    | checkFirstLine a && checkForContent b && checkForEndParen c && checkForFuncStart d = a : (b ++ " " ++ c) : d : processLine rest
    | otherwise = a : processLine (b:c:d:rest)
processLine lines = lines

processFile :: FilePath -> IO ()
processFile path = do
    contents <- readFile path
    let lines = lines contents
        newLines = processLine lines
    writeFile path (unlines newLines)

main :: IO ()
main = do
    let dirPath = "./" -- Current directory
    files <- listDirectory dirPath
    let cFiles = filter (\f -> takeExtension f == ".c") files
    forM_ cFiles $ \file -> do
        putStrLn $ "Processing file: " ++ file
        processFile (dirPath ++ file)
    putStrLn "Done processing files!"
