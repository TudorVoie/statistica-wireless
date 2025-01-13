#!/bin/bash

# Input JSON file
INPUT_JSON="wifi_networks.json"

# Output HTML file
OUTPUT_HTML="index.html"

rm -f $OUTPUT_HTML

DATA=$(date)

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
    <table id="myTable2">
        <thead>
            <tr>
                <th onclick="sortTable(0)">SSID</th>
                <th onclick="sortTable(1)">Vendor</th>
                <th onclick="sortTable(2)">MAC Address</th>
                <th onclick="sortTable(3)">Channel</th>
                <th onclick="sortTable(4)">Frequency</th>
                <th onclick="sortTable(5)">Encryption</th>
            </tr>
        </thead>
        <tbody>
EOF

# Parse the JSON file and append rows to the HTML table
jq -r '.[] | "<tr><td>\(.SSID)</td><td>\(.Vendor)</td><td>\(.MAC)</td><td>\(.Channel)</td><td>\(.Frequency)</td><td>\(.Encryption)</td></tr>"' "$INPUT_JSON" >> "$OUTPUT_HTML"

# Close the HTML tags
cat >> "$OUTPUT_HTML" <<EOF
        </tbody>
    </table>
    <script>
function sortTable(n) {
  var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
  table = document.getElementById("myTable2");
  switching = true;
  // Set the sorting direction to ascending:
  dir = "asc";
  /* Make a loop that will continue until
  no switching has been done: */
  while (switching) {
    // Start by saying: no switching is done:
    switching = false;
    rows = table.rows;
    /* Loop through all table rows (except the
    first, which contains table headers): */
    for (i = 1; i < (rows.length - 1); i++) {
      // Start by saying there should be no switching:
      shouldSwitch = false;
      /* Get the two elements you want to compare,
      one from current row and one from the next: */
      x = rows[i].getElementsByTagName("TD")[n];
      y = rows[i + 1].getElementsByTagName("TD")[n];
      /* Check if the two rows should switch place,
      based on the direction, asc or desc: */
      if (dir == "asc") {
        if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
          // If so, mark as a switch and break the loop:
          shouldSwitch = true;
          break;
        }
      } else if (dir == "desc") {
        if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
          // If so, mark as a switch and break the loop:
          shouldSwitch = true;
          break;
        }
      }
    }
    if (shouldSwitch) {
      /* If a switch has been marked, make the switch
      and mark that a switch has been done: */
      rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
      switching = true;
      // Each time a switch is done, increase this count by 1:
      switchcount ++;
    } else {
      /* If no switching has been done AND the direction is "asc",
      set the direction to "desc" and run the while loop again. */
      if (switchcount == 0 && dir == "asc") {
        dir = "desc";
        switching = true;
      }
    }
  }
}
</script>
    <footer>
        <center>
            Generated at: $DATA
        </center>
    </footer>
</body>
</html>
EOF

# Output message
echo "HTML table created at $OUTPUT_HTML"
