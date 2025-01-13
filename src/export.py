import os
import re
import json

# Directory containing the txt files
directory = "scans"

# Regex patterns to extract relevant information
patterns = {
    "mac": re.compile(r"Address: ([0-9A-Fa-f:]{17})"),
    "ssid": re.compile(r"ESSID:\"(.*?)\""),
    "encryption": re.compile(r"Encryption key:(\w+)"),
    "channel": re.compile(r"Channel:(\d+)"),
    "frequency": re.compile(r"Frequency:(\d+\.\d+)"),
}

def load_vendor_database(database_path):
    """Loads the vendor database from a JSON file."""
    with open(database_path, "r") as db_file:
        vendor_data = json.load(db_file)
    return {entry["macPrefix"].upper(): entry["vendorName"] for entry in vendor_data}

def parse_iwlist_file(filepath):
    """Parses an iwlist output file and extracts WiFi network details."""
    networks = []
    with open(filepath, "r") as file:
        content = file.read()
        cells = content.split("Cell")
        for cell in cells[1:]:
            mac = patterns["mac"].search(cell)
            ssid = patterns["ssid"].search(cell)
            encryption = patterns["encryption"].search(cell)
            channel = patterns["channel"].search(cell)
            frequency = patterns["frequency"].search(cell)
            
            if mac:
                networks.append({
                    "MAC": mac.group(1),
                    "SSID": ssid.group(1) if ssid else "<hidden>",
                    "Encryption": "Enabled" if encryption and encryption.group(1) == "on" else "Disabled",
                    "Channel": channel.group(1) if channel else "Unknown",
                    "Frequency": frequency.group(1) if frequency else "Unknown",
                })
    return networks

def main():
    all_networks = []

    # Load the vendor database
    vendor_database_path = os.path.join(os.getcwd(), "database.json")
    if not os.path.exists(vendor_database_path):
        print("Vendor database not found!")
        return
    vendor_database = load_vendor_database(vendor_database_path)

    # Iterate over files in the specified directory
    for filename in os.listdir(directory):
        if filename.endswith(".txt"):
            filepath = os.path.join(directory, filename)
            all_networks.extend(parse_iwlist_file(filepath))
            os.remove(filepath)  # Delete the file after processing

    # Remove duplicates based on MAC address
    unique_networks = {}
    for network in all_networks:
        mac_prefix = network["MAC"][:8].upper()
        vendor = vendor_database.get(mac_prefix, "Unknown")
        network["Vendor"] = vendor
        unique_networks[network["MAC"]] = network

    # Load existing data if the JSON file exists
    output_path = os.path.join(os.getcwd(), "wifi_networks.json")
    if os.path.exists(output_path):
        with open(output_path, "r") as json_file:
            existing_data = json.load(json_file)
        for network in existing_data:
            unique_networks[network["MAC"]] = network

    # Save updated data to JSON file
    with open(output_path, "w") as json_file:
        json.dump(list(unique_networks.values()), json_file, indent=4)

    print(f"Extracted data saved to {output_path}")

if __name__ == "__main__":
    main()
