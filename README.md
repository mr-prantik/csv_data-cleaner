# CSV Data Cleaner

A shell script to clean and preprocess CSV files by removing empty rows, columns, duplicate entries, special characters, and other common issues. This project helps automate the process of cleaning datasets for analysis, reporting, or storage.

## Features

- **Remove Empty Rows**: Removes any rows that are completely empty.
- **Remove Empty Columns**: Cleans up any columns where all values are missing.
- **Remove Duplicate Rows**: Identifies and removes duplicate rows in the dataset.
- **Remove Special Characters**: Cleans the dataset of any non-alphanumeric characters (except commas for CSV format).
- **Flexible and Simple**: Easily customizable to add or remove cleaning steps based on user needs.

## Requirements

You can run this project using basic Linux utilities available on most systems. Ensure the following tools are installed:
- `awk`
- `sed`
- `sort`
- `uniq`

Alternatively, you can install additional CSV tools for more complex manipulations:
- `csvtool` (optional)
- `csvkit` (optional)

## Usage

To use this script, run it from the command line with the path to your CSV file as an argument:

```bash
./csv_cleaner.sh data.csv


