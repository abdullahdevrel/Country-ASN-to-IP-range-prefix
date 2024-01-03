#!/bin/bash

# Step 1: Download country-asn data
ipinfo download country-asn -f csv > ./country_asn.csv

# Step 2: Format target.txt
sed 's/[[:space:]]*$//; s/^/,/; s/$/,/' target.txt > format_target.txt

# Step 3: Filter country_asn.csv using format_target.txt
(head -1 country_asn.csv; grep -f format_target.txt country_asn.csv) > filtered_country_asn.csv

# Step 4: Convert IP ranges to CIDR format
ipinfo range2cidr ./filtered_country_asn.csv > ./filtered_country_asn_cidr.csv

# Step 5: Extract the first column from filtered_country_asn_cidr.csv
awk -F ',' 'NR > 1 {print $1}' filtered_country_asn_cidr.csv > ip_ranges.txt
