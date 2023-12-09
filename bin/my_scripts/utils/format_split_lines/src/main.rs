use std::fs::{self, File};
use std::io::{self, prelude::*, BufReader};
use regex::Regex;
use glob::glob;

fn get_function_name(line: &str) -> Option<String> {
    let re = Regex::new(r"\b(\w+)\s*\(").unwrap();
    re.captures(line).and_then(|caps| caps.get(1).map(|m| m.as_str().to_string()))
}

fn check_first_line(line: &str) -> bool {
    let temp_line = line.trim();
    (temp_line.is_empty() || temp_line.starts_with('/') || temp_line.starts_with('*')) && !temp_line.starts_with('#')
}

fn check_for_comment(line: &str) -> bool {
    let trimmed = line.trim();
    trimmed.starts_with('/') || trimmed.starts_with('*')
}

fn check_for_content(line: &str) -> bool {
    let trimmed = line.trim();
    !trimmed.is_empty() && !check_for_comment(trimmed) && !trimmed.starts_with('#')
}

fn check_for_paren(line: &str) -> bool {
    line.trim().contains('(')
}

fn check_for_end_paren(line: &str) -> bool {
    line.trim().ends_with(')')
}

fn check_for_func_start(line: &str) -> bool {
    line.trim_end().ends_with('{')
}

fn process_file(filename: &str) -> io::Result<usize> {
    let file = File::open(filename)?;
    let reader = BufReader::new(file);

    let mut new_lines = Vec::new();
    let mut change_counter = 0;
    let lines: Vec<_> = reader.lines().collect::<Result<_, _>>()?;

    let mut i = 0;
    while i < lines.len() {
        if i < lines.len() - 2 && check_first_line(&lines[i]) && check_for_end_paren(&lines[i + 1]) && check_for_func_start(&lines[i + 2]) {
            new_lines.push(lines[i].clone());
            if let Some(func_name) = get_function_name(&lines[i + 1]) {
                let return_type = lines[i + 1].split(&func_name).next().unwrap().to_string();
                new_lines.push(return_type.trim().to_string());
                new_lines.push(lines[i + 1].splitn(2, &return_type).nth(1).unwrap().to_string());
                new_lines.push(lines[i + 2].clone());
            }
            i += 3;
            change_counter += 1;
        } else if i < lines.len() - 3 && check_first_line(&lines[i]) && check_for_paren(&lines[i + 1]) && check_for_end_paren(&lines[i + 2]) && check_for_func_start(&lines[i + 3]) {
            new_lines.push(lines[i].clone());
            if let Some(func_name) = get_function_name(&lines[i + 1]) {
                let return_type = lines[i + 1].split(&func_name).next().unwrap().to_string();
                new_lines.push(return_type.trim().to_string());
                new_lines.push(lines[i + 1].splitn(2, &return_type).nth(1).unwrap().to_string());
                new_lines.push(lines[i + 2].clone());
                new_lines.push(lines[i + 3].clone());
            }
            i += 4;
            change_counter += 1;
        } else if i < lines.len() - 4 && check_first_line(&lines[i]) && !check_for_comment(&lines[i + 1]) && check_for_paren(&lines[i + 1]) && !check_for_comment(&lines[i + 2]) && check_for_content(&lines[i + 2]) && check_for_end_paren(&lines[i + 3]) && check_for_func_start(&lines[i + 4]) {
            println!("Found function with three lines of arguments, see: {}{}{}{}", lines[i + 1], lines[i + 2], lines[i + 3], lines[i + 4]);
            new_lines.push(lines[i].clone());
            i += 1;
        } else {
            new_lines.push(lines[i].clone());
            i += 1;
        }
    }

    // fs::write(filename, new_lines.join("\n"))?;
    // Check if the original content ended with a newline
    let ends_with_newline = lines.last().map_or(false, |line| line.is_empty());

    let mut output = new_lines.join("\n");
    if ends_with_newline {
        output.push('\n'); // Append a newline character at the end of the file
    }

    fs::write(filename, output)?;

    Ok(change_counter)
}

fn main() -> io::Result<()> {
    let path = "./"; // Current directory
    let mut total_change_count = 0;

    for entry in glob(&format!("{}*.c", path)).expect("Failed to read glob pattern") {
        match entry {
            Ok(path) => {
                let path_str = path.to_str().unwrap();
                println!("Processing file: {}", path_str);
                let file_change_count = process_file(path_str)?;
                println!("Done! Changes done: {}", file_change_count);
                total_change_count += file_change_count;
            },
            Err(e) => println!("{:?}", e),
        }
    }

    println!("Done processing files! Total changes done: {}", total_change_count);
    Ok(())
}
