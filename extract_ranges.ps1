# Step 1: Download country-asn data
ipinfo download country-asn -f csv > ./country_asn.csv

# Step 2: Format target.txt
(Get-Content -Path 'target.txt' | ForEach-Object { $_ -replace '\s*$', '' -replace '^', ',' -replace '$', ',' }) -join "`n" | Set-Content -NoNewline -Path 'format_target.txt'

# Step 3: Filter country_asn.csv using format_target.txt
(Get-Content country_asn.csv | Select-Object -First 1) | Out-File -FilePath filtered_country_asn.csv -Encoding utf8
(Get-Content country_asn.csv | Select-String -Pattern (Get-Content format_target.txt)) | Out-File -NoNewline -FilePath filtered_country_asn.csv -Append -Encoding utf8

# Step 4: Convert IP ranges to CIDR format
ipinfo range2cidr ./filtered_country_asn.csv > ./filtered_country_asn_cidr.csv

# Step 5: Extract the first column from filtered_country_asn_cidr.csv
(Get-Content "filtered_country_asn_cidr.csv" | Select-Object -Skip 1 | ForEach-Object { ($_ -split ',')[0] }) | Out-File -FilePath "ip_ranges.txt"
