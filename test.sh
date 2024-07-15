###
# clone_repo_if_missing
###

justInform=false

clone_repo_if_missing() {
    local repo_dir=$1
    local repo_url=$2
    local branch=$3
    local parent_dir="."

    my_repo_dirs=("my_notes" "utils" "my_js" "my_cplusplus")

    echo "--------------------------------------------------------"
    if printf '%s\n' "${my_repo_dirs[@]}" | grep -q "^$repo_dir$"; then
    #if [[ "${repo_dir,,}" == "my_notes" || "${repo_dir,,}" == "utils" ]]; then
        if [ -z "$GITHUB_TOKEN" ]; then
            echo "Error: GITHUB_TOKEN environment variable is not set. Skipping $repo_dir..."
            return 1
        fi
    fi

    # Case insensitive check
    if find "$parent_dir" -maxdepth 1 -type d -iname "$(basename "$repo_dir")" | grep -iq "$(basename "$repo_dir")$"; then
        echo "$repo_dir already cloned."
        return 0
    else
        if $justInform; then
            echo "$repo_dir NOT cloned."
            return 0
        fi
        echo "Cloning $repo_dir from $repo_url"

        # Clone based on specific cases
        local clone_cmd="git clone --recurse-submodules"

        if [[ "${repo_dir,,}" == "trinitycore" || "${repo_dir,,}" == "simc" ]]; then
            clone_cmd="$clone_cmd --single-branch --depth 1"
        fi

        if [ -n "$branch" ]; then
            clone_cmd="$clone_cmd -b $branch"
        fi

        # Check if the lowercase repo_dir exists in the my_repo_dirs array
        #if [[ "${repo_dir,,}" == "my_notes" || "${repo_dir,,}" == "utils" ]]; then
        if printf '%s\n' "${my_repo_dirs[@]}" | grep -q "^$repo_dir$"; then
            repo_url="${repo_url/https:\/\//https:\/\/$GITHUB_TOKEN@}"
        fi

        clone_cmd="$clone_cmd $repo_url $repo_dir"
        #eval "$clone_cmd"
        echo "$clone_cmd"
        return $?
    fi
}

# instead of: if printf '%s\n' "${my_repo_dirs[@]}" | grep -q "^$repo_dir$"; then
# these two options can be used:

# if echo "my_notes utils my_js my_cplusplus" | grep -qw "${repo_dir,,}"; then repo_url="${repo_url/https:\/\//https:\/\/$GITHUB_TOKEN@}"; fi

my_repo_dirs=("my_notes" "utils" "my_js" "my_cplusplus")
# repo_dir_lower="${repo_dir,,}"
# 
# for dir in "${my_repo_dirs[@]}"; do
#     if [[ "$repo_dir_lower" == "$dir" ]]; then
#         repo_url="${repo_url/https:\/\//https:\/\/$GITHUB_TOKEN@}"
#         break
#     fi
# done

clone_repo_if_missing "my_notes" "https://github.com/archornf/my_notes"
clone_repo_if_missing "neovim" "https://github.com/neovim/neovim"
clone_repo_if_missing "vmangos" "https://github.com/ornfelt/vmangos"
clone_repo_if_missing "utils" "https://github.com/ornfelt/utils"

###
# check_file
###
check_file() {
    local dir_name=$1
    local file_path=$2
    echo "--------------------------------------------------------"

    # Capture the actual directory name, preserving its case
    #local actual_dir_name=$(find . -maxdepth 1 -type d -iname "$dir_name" -exec basename {} \; | head -n 1)
    # Use loop instead to get rid of find basename terminated by signal 13...
    while IFS= read -r path; do
        actual_dir_name=$(basename "$path")
        break
    done < <(find . -maxdepth 1 -type d -iname "${dir_name}")

    local full_file_path="./${actual_dir_name}/${file_path}"

    #if [ -f "$full_file_path" ]; then
    # Check case-insensitively if the file exists
    if find "$(dirname "$full_file_path")" -maxdepth 1 -type f -iname "$(basename "$full_file_path")" 2>/dev/null | grep -iq "$(basename "$full_file_path")$" >/dev/null 2>&1; then
        echo "${dir_name} already compiled."
        return 1 # Return false
    else
        echo "File ${file_path} in ${dir_name} does not exist."
        if $justInform; then
            echo "${dir_name} NOT compiled."
            return 1
        fi

        if ! ask_for_compile "$dir_name"; then
            return 1
        fi

        echo "Entering ${actual_dir_name}..."
        cd "./${actual_dir_name}"
        return 0 # Return true
    fi
}

if check_file "Craft" "craft"; then
if check_file "crispy-doom" "src/crispy-doom"; then
if check_file "wowmapviewer" "bin/wowmapview"; then

###
# check_dir
###
check_dir() {
    local dir_name=$1
    local dir_type=${2:-build} # Default to build
    echo "--------------------------------------------------------"

    # Capture the actual directory name, preserving its case
    #local actual_dir_name=$(find . -maxdepth 1 -type d -iname "${dir_name}" -exec basename {} \; | head -n 1)
    # Use loop instead to get rid of find basename terminated by signal 13...
    while IFS= read -r path; do
        actual_dir_name=$(basename "$path")
        break
    done < <(find . -maxdepth 1 -type d -iname "${dir_name}")
    
    if [[ -n "$actual_dir_name" ]]; then
        local target_dir="./${actual_dir_name}/${dir_type}"

        # Check if the directory exists based on the dir_type pattern
        if [[ "$dir_type" == "build*" ]]; then
            # Use find and grep to check for the existence of matching directories
            if find "./${actual_dir_name}" -maxdepth 1 -type d -name "${dir_type}" | grep -q .; then
                echo "${target_dir} already compiled."
                return 1 # Return false
            else
                if $justInform; then
                    echo "${target_dir} NOT compiled."
                    return 1
                fi

                if ! ask_for_compile "$dir_name"; then
                    return 1
                fi
    
                echo "Entering ${actual_dir_name}..."
                cd "./${actual_dir_name}"
                sleep 1
                return 0 # Return true
            fi
        else
            if [ -d "$target_dir" ]; then
                echo "${target_dir} already compiled."
                return 1 # Return false
            else
                if $justInform; then
                    echo "${target_dir} NOT compiled."
                    return 1
                fi

                if ! ask_for_compile "$dir_name"; then
                    return 1
                fi

                if [[ "$dir_type" == *"build"* ]]; then
                    echo "Creating and entering ${target_dir}..."
                    mkdir -p "$target_dir" && cd "$target_dir"
                else
                    echo "Entering ${actual_dir_name}..."
                    cd "./${actual_dir_name}"
                fi
                sleep 1
                return 0 # Return true
            fi
        fi
    else
        echo "Directory $dir_name does not exist."
        return 1 # Return false
    fi
}

if check_dir "StormLib"; then
if check_dir "spelunker" "node_modules"; then
if check_dir "OpenJKDF2" "build*"; then

