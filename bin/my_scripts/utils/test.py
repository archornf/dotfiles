import re

def get_function_name(line):
    # Regular expression to find the last word before parentheses
    match = re.search(r'\b(\w+)\s*\(', line)
    if match:
        return match.group(1)  # Returns the captured group, which is the function name
    else:
        return None  # No match found

# Test the function with examples
print(get_function_name("void test(ushort x)"))             # Should return "test"
print(get_function_name("static int abc(ushort x)"))        # Should return "abc"
print(get_function_name("static int abcd (uintt x)"))       # Should return "abcd"
print(get_function_name("pid_t getparentprocess(pid_t p)")) # Should return getparentprocess
print(get_function_name("size_t utf8decode(const char *c, Rune *u, size_t clen)")) # Should return utf8decode

def get_return_type(line):
    # Regular expression to find everything before the last word (function name) and opening parenthesis
    match = re.search(r'^(.*?)\s*\b\w+\s*\(', line)
    if match:
        return match.group(1).strip()  # Returns the captured group, which is the return type
    else:
        return None  # No match found

# Test the function with examples
print("-----------------------------------")
print(get_return_type("void test(ushort x)"))               # Should return "void"
print(get_return_type("static int abc(ushort x)"))          # Should return "static int"
print(get_return_type("static int abcd (uintt x)"))         # Should return "static int"
print(get_return_type("pid_t getparentprocess(pid_t p)"))   # Should return pid_t
print(get_return_type("size_t utf8decode(const char *c, Rune *u, size_t clen)")) # Should return size_t
