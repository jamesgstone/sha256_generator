#!/bin/bash

# Set the directory to search for .exe files
dir="./"

# Set the log file
log_file="sha256.log"

# Iterate over all .exe files in the directory
for file in $dir/*.exe; do
  # Check if a .sha256 file already exists for the current file
  if [ -f "${file}.sha256" ]; then
    # A .sha256 file already exists, so verify the existing hash
    # Calculate the SHA256 hash of the current file
    calculated_hash=$(sha256sum "$file" | cut -d " " -f 1)
    # Read the stored hash from the .sha256 file
    stored_hash=$(cat "${file}.sha256")
    # Compare the calculated hash with the stored hash
    if [ "$calculated_hash" == "$stored_hash" ]; then
      # The hashes match, so skip this file
      # Log the result
      echo "$(date): Skipped file $file - hashes match" >> $log_file
      continue
    else
      # The hashes do not match, so display an error message and exit
      echo "$(date): Error: Hash for file $file does not match stored hash!" >> $log_file
      exit 1
    fi
  else
    # No .sha256 file exists, so calculate the SHA256 hash of the current file
    # and store it in a .sha256 file
    sha256sum "$file" > "${file}.sha256"
    # Log the result
    echo "$(date): Calculated hash for file $file" >> $log_file
  fi
done

# All .exe files have been processed
echo "$(date): Finished processing all .exe files in directory $dir" >> $log_file
