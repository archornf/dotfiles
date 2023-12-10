import glob

def check_first_line(line):
    temp_line = line.strip()
    return (temp_line == '' or temp_line.startswith('/') or temp_line.startswith('*')) and not temp_line.startswith('#')

def check_for_comment(line):
    return line.strip().startswith('/') or line.strip().startswith("*")

def check_for_content(line):
    return line.strip() != '' and not check_for_comment(line) and not line.strip().startswith('#')

def check_for_paren(line):
    return '(' in line.strip()

def check_for_end_paren(line):
    return line.strip().endswith(')')

def check_for_func_start(line):
    return line.replace('\n', '').startswith('{')

def process_file(filename):
    change_counter = 0
    with open(filename, 'r') as file:
        lines = file.readlines()

    new_lines = []
    i = 0
    while i < len(lines):
        if i < len(lines) - 3 and check_first_line(lines[i]) and check_for_content(lines[i+1]) and check_for_end_paren(lines[i+2]) and check_for_func_start(lines[i+3]):
            new_lines.append(lines[i])
            new_lines.append(lines[i+1].rstrip() + ' ' + lines[i+2].rstrip() + '\n')
            new_lines.append(lines[i+3])
            i += 4
            change_counter += 1
        elif i < len(lines) - 4 and check_first_line(lines[i]) and check_for_content(lines[i+1]) and check_for_paren(lines[i+2]) and check_for_end_paren(lines[i+3]) and check_for_func_start(lines[i+4]):
            new_lines.append(lines[i])
            new_lines.append(lines[i+1].rstrip() + ' ' + lines[i+2].rstrip() + '\n')
            new_lines.append(lines[i+3])
            new_lines.append(lines[i+4])
            i += 5
            change_counter += 1
        elif i < len(lines) - 5 and check_first_line(lines[i]) and check_for_content(lines[i+1]) and check_for_paren(lines[i+2]) and check_for_content(lines[i+3]) and check_for_end_paren(lines[i+4]) and check_for_func_start(lines[i+5]):
            print(f"Found function with three lines of arguments, see: {lines[i+1] + lines[i+2] + lines[i+3] + lines[i+4]}")
            new_lines.append(lines[i])
            i += 1
        else:
            new_lines.append(lines[i])
            i += 1

    with open(filename, 'w') as file:
        file.writelines(new_lines)
    return change_counter

# Replace the path with the directory where your .c files are located
path = './' # Current directory
total_change_count = 0
for filename in glob.glob(path + '*.c'):
    print(f'Processing file: {filename}')
    file_change_count = process_file(filename)
    print(f"Done! Changes done: {file_change_count}")
    total_change_count += file_change_count

print(f"Done processing files! Total changes done: {total_change_count}")
