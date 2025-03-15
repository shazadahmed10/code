# Sample Python script to manipulate NBA all_seasons.csv dataset using Pandas

import pandas as pd

# Load the CSV file
file_path = "all_seasons.csv"  # Ensure the file is in the same directory or provide the full path
df = pd.read_csv(file_path)

# Rename columns for clarity
df.rename(columns={"player_name": "Player", "team_abbreviation": "Team", "pts": "Points"}, inplace=True)

# Replace specific values in a categorical column (example: changing 'USA' to 'United States')
df["country"] = df["country"].replace({"USA": "United States"})

# Convert 'draft_year' to numeric (some values might be 'Undrafted', so we handle errors)
df["draft_year"] = pd.to_numeric(df["draft_year"], errors="coerce")

# Create a conditional column based on Points per game
df["Performance Category"] = df["Points"].apply(lambda x: "High Scorer" if x > 15 else "Average")

# Test to ensure the script executed correctly
try:
    assert not df.empty, "Error: DataFrame is empty after processing!"
    assert "Performance Category" in df.columns, "Error: Conditional column not created!"
    print("Script executed successfully!")
except AssertionError as e:
    print(f"Test failed: {e}")

# Save the cleaned data
output_path = "all_seasonsV2.csv"
df.to_csv(output_path, index=False)

