#!/bin/bash

# Initialize flags
REMOVE_EMPTY_ROWS=false
REMOVE_DUPLICATES=false
REMOVE_SPECIAL_CHARS=false
REMOVE_EMPTY_COLUMNS=false

# Function to check if the file exists and is a valid CSV
check_file() {
    if [ ! -f "$1" ]; then
        echo "Error: File '$1' not found!"
        exit 1
    fi

    # Check if the file is a valid CSV by checking the extension
    if [[ "$1" != *.csv ]]; then
        echo "Error: '$1' is not a CSV file!"
        exit 1
    fi

    # Check for malformed CSV by verifying consistent column counts
    local column_count=$(head -1 "$1" | awk -F, '{print NF}')
    while IFS= read -r line; do
        local line_count=$(echo "$line" | awk -F, '{print NF}')
        if [ "$line_count" -ne "$column_count" ]; then
            echo "Error: Malformed CSV detected! Line with inconsistent columns: '$line'"
            exit 1
        fi
    done < "$1"
}

# Function to remove empty rows
remove_empty_rows() {
    awk 'NF > 0' "$1" > temp.csv && mv temp.csv "$1"
    echo "Empty rows removed."
}

# Function to remove duplicate rows
remove_duplicates() {
    sort "$1" | uniq > temp.csv && mv temp.csv "$1"
    echo "Duplicates removed."
}

# Function to remove special characters
remove_special_chars() {
    sed 's/[^a-zA-Z0-9,]//g' "$1" > temp.csv && mv temp.csv "$1"
    echo "Special characters removed."
}

# Function to remove empty columns
remove_empty_columns() {
    awk -F, '{
        for (i=1; i<=NF; i++) {
            if ($i != "")
                printf "%s%s", $i, (i==NF ? "\n" : FS)
        }
    }' "$1" > temp.csv && mv temp.csv "$1"
    echo "Empty columns removed."
}

# Function to display usage instructions
usage() {
    echo "Usage: $0 [OPTIONS] [csv_file]"
    echo "Options:"
    echo "  -e, --empty-rows         Remove empty rows"
    echo "  -d, --duplicates         Remove duplicate rows"
    echo "  -s, --special-chars      Remove special characters"
    echo "  -c, --empty-columns      Remove empty columns"
    echo "  -h, --help               Display this help and exit"
    echo "Example: ./csv_cleaner.sh -e -d -s -c data.csv"
    exit 1
}

# Parse command-line arguments
if [ $# -eq 0 ]; then
    usage
fi

# Read flags
while [[ $# -gt 0 ]]; do
    case "$1" in
        -e|--empty-rows)
            REMOVE_EMPTY_ROWS=true
            shift
            ;;
        -d|--duplicates)
            REMOVE_DUPLICATES=true
            shift
            ;;
        -s|--special-chars)
            REMOVE_SPECIAL_CHARS=true
            shift
            ;;
        -c|--empty-columns)
            REMOVE_EMPTY_COLUMNS=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            CSV_FILE="$1"
            shift
            ;;
    esac
done

# Check if a CSV file is provided
if [ -z "$CSV_FILE" ]; then
    echo "Error: No CSV file provided."
    usage
fi

# Check if the file is valid
check_file "$CSV_FILE"

# Perform selected CSV cleaning operations
$REMOVE_EMPTY_ROWS && remove_empty_rows "$CSV_FILE"
$REMOVE_DUPLICATES && remove_duplicates "$CSV_FILE"
$REMOVE_SPECIAL_CHARS && remove_special_chars "$CSV_FILE"
$REMOVE_EMPTY_COLUMNS && remove_empty_columns "$CSV_FILE"

echo "CSV cleaning complete!"
