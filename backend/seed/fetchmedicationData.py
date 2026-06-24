# import csv
# import requests
# from pathlib import Path

# BASE_URL = "https://api.fda.gov/drug/ndc.json"

# LIMIT = 100
# MAX_RECORDS = 5000  # adjust as needed

# CSV_FILE = "medicines.csv"

# headers = [
#     "product_ndc",
#     "generic_name",
#     "brand_name",
#     "manufacturer_name",
#     "dosage_form",
#     "route",
# ]

# # Create CSV with header if it doesn't exist
# if not Path(CSV_FILE).exists():
#     with open(CSV_FILE, "w", newline="", encoding="utf-8") as file:
#         writer = csv.writer(file)
#         writer.writerow(headers)

# for skip in range(0, MAX_RECORDS, LIMIT):
#     print(f"Fetching records {skip} - {skip + LIMIT}")

#     response = requests.get(
#         BASE_URL,
#         params={
#             "limit": LIMIT,
#             "skip": skip,
#         },
#     )

#     response.raise_for_status()

#     data = response.json()

#     results = data.get("results", [])

#     if not results:
#         print("No more records.")
#         break

#     with open(CSV_FILE, "a", newline="", encoding="utf-8") as file:
#         writer = csv.writer(file)

#         for item in results:
#             writer.writerow([
#                 item.get("product_ndc", ""),
#                 item.get("generic_name", ""),
#                 item.get("brand_name", ""),
#                 item.get("labeler_name", ""),
#                 item.get("dosage_form", ""),
#                 ", ".join(item.get("route", [])),
#             ])

# print("Done.")

import csv
import requests
from pathlib import Path

BASE_URL = "https://api.fda.gov/drug/ndc.json"

LIMIT = 100
MAX_RECORDS = 5000

CSV_FILE = "medicines.csv"

HEADERS = [
    "product_ndc",
    "generic_name",
    "brand_name",
    "manufacturer_name",
    "dosage_form",
    "route",
    "strength",
    "strength_unit",
    "description",
]

# Create CSV file with header if it doesn't exist
if not Path(CSV_FILE).exists():
    with open(CSV_FILE, "w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        writer.writerow(HEADERS)


def extract_strength(active_ingredients):
    """
    Example strength strings:
        '500 mg/1'
        '100 mcg/1'
        '250 MG'
    """

    if not active_ingredients:
        return "", ""

    strength_string = active_ingredients[0].get("strength", "")

    if not strength_string:
        return "", ""

    parts = strength_string.split()

    if len(parts) < 2:
        return strength_string, ""

    strength = parts[0]

    # Convert "mg/1" -> "mg"
    unit = parts[1].split("/")[0]

    return strength, unit


for skip in range(0, MAX_RECORDS, LIMIT):

    print(f"Fetching records {skip} - {skip + LIMIT}")

    response = requests.get(
        BASE_URL,
        params={
            "limit": LIMIT,
            "skip": skip,
        },
        timeout=30,
    )

    response.raise_for_status()

    data = response.json()

    results = data.get("results", [])

    if not results:
        print("No more records found.")
        break

    with open(CSV_FILE, "a", newline="", encoding="utf-8") as file:

        writer = csv.writer(file)

        for item in results:

            ingredients = item.get("active_ingredients", [])

            strength, strength_unit = extract_strength(ingredients)

            row = [
                item.get("product_ndc", ""),
                item.get("generic_name", ""),
                item.get("brand_name", ""),
                item.get("labeler_name", ""),
                item.get("dosage_form", ""),
                ", ".join(item.get("route", [])),
                strength,
                strength_unit,
                "",  # description placeholder
            ]

            writer.writerow(row)

print("Finished.")
