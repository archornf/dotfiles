import os
import filecmp
import fnmatch

def list_source_files(directory, extensions):
    matches = []
    for root, dirnames, filenames in os.walk(directory):
        if '.git' in dirnames:
            dirnames.remove('.git')
        for extension in extensions:
            for filename in fnmatch.filter(filenames, f'*.{extension}'):
                matches.append(os.path.relpath(os.path.join(root, filename), directory))
    return set(matches)

def compare_directories(dir1, dir2):
    # List of common programming source file extensions
    extensions = ['cpp', 'c', 'py', 'h', 'hpp', 'java', 'cs', 'js', 'ts', 'html', 'css', 'php', 'rb', 'go', 'swift', 'kt', 'rs']

    files1 = list_source_files(dir1, extensions)
    files2 = list_source_files(dir2, extensions)

    # Files that are common in both directories
    common_files = files1.intersection(files2)
    # Files that are only in dir1 or only in dir2
    only_in_dir1 = files1 - files2
    only_in_dir2 = files2 - files1
    files_do_differ = False

    for file in common_files:
        path1 = os.path.join(dir1, file)
        path2 = os.path.join(dir2, file)

        if not filecmp.cmp(path1, path2, shallow=False):
            print(f"Common file that differ: {path1} and {path2}")
            files_do_differ = True

    print()
    if not files_do_differ:
        print("All common source files are the same!\n")

    for file in only_in_dir1:
        print(f"Only in {dir1}: {file}")
    print()

    for file in only_in_dir2:
        print(f"Only in {dir2}: {file}")

if __name__ == "__main__":
    #dir1 = input("Enter the path for the first directory: ")
    #dir2 = input("Enter the path for the second directory: ")
    dir1 = "/home/jonas/Downloads/suckless/st"
    dir2 = "/home/jonas/Downloads/suckless/dwm"

    compare_directories(dir1, dir2)
