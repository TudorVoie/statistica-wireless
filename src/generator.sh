#!/bin/bash

# Input JSON file
INPUT_JSON="wifi_scan.json"

# Output HTML file
OUTPUT_HTML="index.html"

rm -f $OUTPUT_HTML

# Start the HTML file with basic structure
cat > "$OUTPUT_HTML" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistica</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f4f4f4;
        }
    </style>
</head>
<body>
    <center>
        <h1>Statistica</h1>
    </center>
    <table>
        <thead>
            <tr>
                <th>SSID</th>
                <th>Manufacturer</th>
                <th>MAC Address</th>
                <th>Channel</th>
                <th>Frequency</th>
                <th>Encryption</th>
            </tr>
        </thead>
        <tbody>
EOF

# Parse the JSON file and append rows to the HTML table
jq -r '.[] | "<tr><td>\(.SSID)</td><td>\(.Manufacturer)</td><td>\(.MAC)</td><td>\(.Channel)</td><td>\(.Frequency)</td><td>\(.Encryption)</td></tr>"' "$INPUT_JSON" >> "$OUTPUT_HTML"

# Close the HTML tags
cat >> "$OUTPUT_HTML" <<EOF
        </tbody>
    </table>
</body>
</html>
EOF

# Output message
echo "HTML table created at $OUTPUT_HTML"
