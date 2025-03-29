#!/bin/bash

# Function to update a single submodule
update_submodule() {
  local submodule_path=$1
  echo "Updating submodule at '$submodule_path'..."

  # Navigate to the submodule directory
  cd "$submodule_path" || exit

  # Check if the 'main' branch exists and switch to it
  if git show-ref --verify --quiet refs/heads/main; then
    git checkout main
  else
    echo "Branch 'main' does not exist in submodule '$submodule_path'. Skipping..."
    cd - || exit
    return
  fi

  # Pull the latest changes from the remote 'main' branch
  git pull origin main

  # Return to the main repository's root directory
  cd - || exit
}

# Main script execution
main() {
  # Ensure we're at the root of the main repository
  if [ ! -f ".gitmodules" ]; then
    echo "No '.gitmodules' file found. Are you sure this is the root of a Git repository?"
    exit 1
  fi

  # Iterate over each submodule listed in .gitmodules
  awk -F' = ' '/^\[submodule/ {submodule_name=$2} submodule_name && /path/ {print submodule_name; submodule_name=""}' .gitmodules | while IFS= read -r submodule_path; do
    update_submodule "$submodule_path"
  done

  # After updating submodules, stage the changes in the main repository
  git add .
  git commit -m "Update submodules to latest 'main' branch commits"
  git push origin main
}

# Run the main function
main
