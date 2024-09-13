#!/bin/bash

# Function to remove empty rows
remove_empty_rows() {
    awk 'NF > 0' $1 > temp.csv && mv temp.csv $1
    echo "Empty rows removed."
}

# Function to remove duplicate rows
remove_duplicates() {
    sort $1 | uniq > temp.csv && mv temp.csv $1
    echo "Duplicates removed."
}

# Function to remove special characters
remove_special_chars() {
    sed 's/[^a-zA-Z0-9,]//g' $1 > temp.csv && mv temp.csv $1
    echo "Special characters removed."
}

# Function to remove empty columns
remove_empty_columns() {
    awk -F, '{
        for (i=1; i<=NF; i++) {
            if ($i != "")
                printf "%s%s", $i, (i==NF ? "\n" : FS)
        }
    }' $1 > temp.csv && mv temp.csv $1
    echo "Empty columns removed."
}

# Function to display usage instructions
usage() {
    echo "Usage: $0 [csv_file]"
    echo "Example: ./csv_cleaner.sh data.csv"
    exit 1
}

# Check if a file argument is provided
if [ -z "$1" ]; then
    usage
fi

# Perform CSV cleaning operations
remove_empty_rows $1
remove_duplicates $1
remove_special_chars $1
remove_empty_columns $1

echo "CSV cleaning complete!"
