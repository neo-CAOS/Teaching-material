#!/bin/zsh

# Colors for enhanced echo messages
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RED="\033[0;31m"
RESET="\033[0m"

# Emojis for better visual distinction # TODO: update
CHECK="✅"
WARNING="⚠️"
FOLDER="📂"
PULL="⬇️"
CLONE="📥"
INFO="ℹ️"
BRANCH="🌿"

# Source the repository URLs and custom names from an external file (urls.txt)
source urls.txt

# Function to check and create a directory if it doesn't exist
# If more than 1 argument is provided, it will process only the first one.
# Args:
#   $1: Directory path to check/create
check_and_create_dir() {
    if [[ $# -gt 1 ]]; then
        echo -e "${YELLOW}${WARNING} Warning: More than 1 argument provided. Only the first argument ($1) will be processed.${RESET}"
    fi
    
    if [[ ! -d "$1" ]]; then
        echo -e "${CYAN}${FOLDER} Creating directory: $1${RESET}"
        mkdir -p "$1"
    else
        echo -e "${GREEN}${CHECK} Directory already exists: $1${RESET}"
    fi
}

# Function to manage personal branch
# Args:
#   $1: full path
manage_personal_branch() { # TODO: check
    local repo_dir=$1
    
    # Store current branch and changes
    local current_branch=$(cd "$repo_dir" && git symbolic-ref --short HEAD)
    
    # Check for uncommitted changes
    if [[ -n "$(cd "$repo_dir" && git status --porcelain)" ]]; then
        echo -e "${YELLOW}${WARNING} Uncommitted changes detected in $repo_dir${RESET}"
        echo -e "${CYAN}${INFO} Stashing changes...${RESET}"
        (cd "$repo_dir" && git stash)
    fi
    
    # Create or switch to personal branch
    if ! (cd "$repo_dir" && git show-ref --verify --quiet refs/heads/personal); then
        echo -e "${CYAN}${BRANCH} Creating personal branch in $repo_dir${RESET}"
        (cd "$repo_dir" && git checkout -b personal)
    else
        # If we were on personal branch, update it with main
        if [[ "$current_branch" == "personal" ]]; then
            echo -e "${CYAN}${BRANCH} Updating personal branch with latest changes${RESET}"
            (cd "$repo_dir" && git checkout main && \
             git pull origin main && \
             git checkout personal && \
             git rebase main)
        fi
    fi
    
    # Restore stashed changes if any
    if [[ -n "$(cd "$repo_dir" && git stash list)" ]]; then
        echo -e "${CYAN}${INFO} Restoring stashed changes...${RESET}"
        (cd "$repo_dir" && git stash pop)
    fi
}

# Function to clone a repository or pull the latest changes if it already exists
# Args:
#   $1: Repository URL
#   $2: Target directory to clone the repo into
#   $3: Custom name for the repository (if provided, otherwise the repo name will be used)
clone_or_pull() {
    local repo_url=$1
    local target_dir=$2
    local custom_name=$3 # Custom name for the directory, if provided
    
    # Extract the repository name from the URL
    local repo_name=$(basename "$repo_url" .git)
    local final_name
    
    # Use custom name if given, otherwise use the repository's default name
    if [[ -n "$custom_name" ]]; then
        final_name="$custom_name"
    else
        final_name="$repo_name"
    fi
    
    # Construct the full path to the target directory
    local full_path="$target_dir/$final_name"
    
    # Check if the repository directory already exists
    if [[ -d "$full_path" ]]; then
        echo -e "${CYAN}${PULL} Repository $final_name already exists. Pulling latest changes... ${RESET}"
        # Pull latest changes from 'main' or 'master' branch, if the repository already exists
        (cd "$full_path" && git pull origin main || git pull origin master)
        # After pulling, ensure all submodules are initialized and updated
        (cd "$full_path" && git submodule update --init --recursive)
        # Manage personal branch
        # manage_personal_branch "$full_path" # TODO: check
    else
        # If the repository doesn't exist, clone it as a submodule
        echo -e "${CYAN}${CLONE} Cloning $final_name into $target_dir ${RESET}"
        git submodule add "$repo_url" "$full_path"
        # Initialize personal branch for new repository
        # manage_personal_branch "$full_path" # TODO: check
    fi
}

# Ensure that the 'Laboratories' and 'Exercises' directories exist
check_and_create_dir "Laboratories"
check_and_create_dir "Exercises"

# Check if we are on the 'main' or 'master' branch, and switch if necessary
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
    # Switch to 'main' branch if it exists, otherwise check for 'master'
    if git show-ref --verify --quiet refs/heads/main; then
        echo -e "${CYAN}${INFO} Switching to main branch${RESET}"
        git checkout main
    elif git show-ref --verify --quiet refs/heads/master; then
        echo -e "${CYAN}${INFO} Switching to master branch${RESET}"
        git checkout master
    else
        echo -e "${RED}${WARNING} Neither 'main' nor 'master' branch exists. Aborting.${RESET}"
        exit 1
    fi
else
    echo "${GREEN}${CHECK} Already on $current_branch branch${RESET}"
fi

# Clone or pull the CAOS repository (main repository for the project)
echo -e "${CYAN}${INFO} Processing CAOS repository${RESET}"
clone_or_pull "$CAOS_REPO" "."

# Clone or pull the Laboratories repositories using the list of URLs and custom names
echo -e "${CYAN}${INFO} Processing Laboratories repositories${RESET}"
for index in {1..$#LABORATORIES}; do
    repo="${LABORATORIES[$index]}"
    custom_name="${LABORATORIES_CUSTOM_NAMES[$index]}"
    clone_or_pull "$repo" "Laboratories" "$custom_name"
done

# Clone or pull the Exercises repositories using the list of URLs and custom names
echo -e "${CYAN}${INFO} Processing Exercises repositories${RESET}"
for index in {1..$#EXERCISES}; do
    repo="${EXERCISES[$index]}"
    custom_name="${EXERCISES_CUSTOM_NAMES[$index]}"
    clone_or_pull "$repo" "Exercises" "$custom_name"
done

# Ensure that all submodules in the entire repository are initialized and updated
# This command recursively initializes and updates any submodules that weren't covered earlier
git submodule update --init --recursive
# Uncomment the next line if you want to fetch the latest remote changes for submodules, but it may cause unintended updates
# git submodule update --recursive --remote

# Add the new command here if you want to force initialize all submodules:
# git submodule update --init --recursive --force

echo -e "${GREEN}${CHECK} All repositories have been processed (cloned or pulled) in their respective directories. ${RESET}"
