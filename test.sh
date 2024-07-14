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


# if echo "my_notes utils my_js my_cplusplus" | grep -qw "${repo_dir,,}"; then repo_url="${repo_url/https:\/\//https:\/\/$GITHUB_TOKEN@}"; fi

# directories=("my_notes" "utils" "my_js" "my_cplusplus")
# repo_dir_lower="${repo_dir,,}"
# 
# for dir in "${directories[@]}"; do
#     if [[ "$repo_dir_lower" == "$dir" ]]; then
#         repo_url="${repo_url/https:\/\//https:\/\/$GITHUB_TOKEN@}"
#         break
#     fi
# done


clone_repo_if_missing "my_notes" "https://github.com/archornf/my_notes"
clone_repo_if_missing "neovim" "https://github.com/neovim/neovim"
clone_repo_if_missing "vmangos" "https://github.com/ornfelt/vmangos"
clone_repo_if_missing "utils" "https://github.com/ornfelt/utils"
