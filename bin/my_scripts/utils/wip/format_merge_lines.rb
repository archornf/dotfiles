require 'find'

def check_first_line(line)
    temp_line = line.strip
    (temp_line.empty? || temp_line.start_with?('/') || temp_line.start_with?('*')) && !temp_line.start_with?('#')
end

def check_for_comment(line)
    line.strip.start_with?('/') || line.strip.start_with?('*')
end

def check_for_content(line)
    !line.strip.empty? && !check_for_comment(line) && !line.strip.start_with?('#')
end

def check_for_paren(line)
    line.strip.include?('(')
end

def check_for_end_paren(line)
    line.strip.end_with?(')')
end

def check_for_func_start(line)
    line.gsub("\n", '').start_with?('{')
end

def process_file(filename)
    lines = File.readlines(filename)
    new_lines = []
    change_counter = 0

    i = 0
    while i < lines.size
        if i < lines.size - 3 && check_first_line(lines[i]) && check_for_content(lines[i + 1]) && check_for_end_paren(lines[i + 2]) && check_for_func_start(lines[i + 3])
            new_lines << lines[i]
            new_lines << lines[i + 1].strip + ' ' + lines[i + 2].strip
            new_lines << lines[i + 3]
            i += 4
            change_counter += 1
        else
            new_lines << lines[i]
            i += 1
        end
    end

    File.write(filename, new_lines.join("\n"))
    change_counter
end

dir_path = './' # Current directory
total_change_count = 0

Find.find(dir_path) do |path|
    next unless path.end_with?('.c')
    puts "Processing file: #{path}"
    file_change_count = process_file(path)
    puts "Done! Changes done: #{file_change_count}"
    total_change_count += file_change_count
end

puts "Done processing files! Total changes done: #{total_change_count}"
