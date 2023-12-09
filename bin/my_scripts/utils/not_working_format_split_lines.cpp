#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include <vector>
#include <filesystem>
namespace fs = std::filesystem;

bool starts_with(const std::string& str, const std::string& prefix) {
    if (str.length() < prefix.length()) {
        return false;
    }
    return str.compare(0, prefix.length(), prefix) == 0;
}

std::string get_function_name(const std::string& line) {
    std::regex r("\\b(\\w+)\\s*\\(");
    std::smatch match;
    if (std::regex_search(line, match, r)) {
        return match[1];
    }
    return "";
}

bool check_first_line(const std::string& line) {
    std::string trimmed = line;
    trimmed.erase(0, trimmed.find_first_not_of(" \t\n\r\f\v"));
    return (!trimmed.empty() && 
           (trimmed[0] == '/' || trimmed[0] == '*') && 
           !starts_with(trimmed, "#"));
}

bool check_for_comment(const std::string& line) {
    std::string trimmed = line;
    trimmed.erase(0, trimmed.find_first_not_of(" \t\n\r\f\v"));
    return trimmed[0] == '/' || trimmed[0] == '*';
}

bool check_for_content(const std::string& line) {
    std::string trimmed = line;
    trimmed.erase(0, trimmed.find_first_not_of(" \t\n\r\f\v"));
    return !trimmed.empty() && !check_for_comment(trimmed) && !starts_with(trimmed, "#");
}

bool check_for_paren(const std::string& line) {
    return line.find('(') != std::string::npos;
}

bool check_for_end_paren(const std::string& line) {
    std::string trimmed = line;
    trimmed.erase(0, trimmed.find_first_not_of(" \t\n\r\f\v"));
    return !trimmed.empty() && trimmed.back() == ')';
}

bool check_for_func_start(const std::string& line) {
    std::string trimmed = line;
    trimmed.erase(0, trimmed.find_first_not_of(" \t\n\r\f\v"));
    return !trimmed.empty() && starts_with(trimmed, "{");
}

int process_file(const std::string& filename) {
    std::ifstream file(filename);
    std::vector<std::string> lines;
    std::string line;
    while (std::getline(file, line)) {
        lines.push_back(line);
    }
    file.close();

    std::vector<std::string> new_lines;
    int change_counter = 0;
    size_t i = 0;

    while (i < lines.size()) {
        if (i < lines.size() - 2 && check_first_line(lines[i]) && check_for_end_paren(lines[i+1]) && check_for_func_start(lines[i+2])) {
            std::string func_name = get_function_name(lines[i+1]);
            std::string return_type = lines[i+1].substr(0, lines[i+1].find(func_name));
            new_lines.push_back(lines[i]);
            new_lines.push_back(return_type + "\n");
            new_lines.push_back(lines[i+1].substr(lines[i+1].find(func_name)));
            new_lines.push_back(lines[i+2]);
            i += 3;
            change_counter++;
        } else if (i < lines.size() - 3 && check_first_line(lines[i]) && check_for_paren(lines[i+1]) && check_for_end_paren(lines[i+2]) && check_for_func_start(lines[i+3])) {
            std::string func_name = get_function_name(lines[i+1]);
            std::string return_type = lines[i+1].substr(0, lines[i+1].find(func_name));
            new_lines.push_back(lines[i]);
            new_lines.push_back(return_type + "\n");
            new_lines.push_back(lines[i+1].substr(lines[i+1].find(func_name)));
            new_lines.push_back(lines[i+2]);
            new_lines.push_back(lines[i+3]);
            i += 4;
            change_counter++;
        } else if (i < lines.size() - 4 && check_first_line(lines[i]) && !check_for_comment(lines[i+1]) && check_for_paren(lines[i+1]) && !check_for_comment(lines[i+2]) && check_for_content(lines[i+2]) && check_for_end_paren(lines[i+3]) && check_for_func_start(lines[i+4])) {
            std::cout << "Found function with three lines of arguments, see: " << lines[i+1] + lines[i+2] + lines[i+3] + lines[i+4] << std::endl;
            new_lines.push_back(lines[i]);
            i += 1;
        } else {
            new_lines.push_back(lines[i]);
            i++;
        }
    }

    std::ofstream out_file(filename);
    for (const auto& ln : new_lines) {
        out_file << ln << std::endl;
    }
    out_file.close();

    return change_counter;
}

int main() {
    std::string path = "./"; // Current directory
    int total_change_count = 0;

    for (const auto& entry : fs::directory_iterator(path)) {
        if (entry.path().extension() == ".c") {
            std::cout << "Processing file: " << entry.path() << std::endl;
            int file_change_count = process_file(entry.path());
            std::cout << "Done! Changes done: " << file_change_count << std::endl;
            total_change_count += file_change_count;
        }
    }

    std::cout << "Done processing files! Total changes done: " << total_change_count << std::endl;

    return 0;
}
