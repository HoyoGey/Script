import os
import re
import json

# Configuration details
github_username = "HoyoGey"
github_repo = "Script"
github_branch = "main"
scripts_dir = "src/scripts"
output_file = "games.json"

# Base URL for raw content from GitHub
base_url = f"https://raw.githubusercontent.com/{github_username}/{github_repo}/refs/heads/{github_branch}/{scripts_dir}"

# Regex patterns to match PlaceId and GameId
place_id_pattern = re.compile(r"--\s*PlaceId:\s*(\d+)")
game_id_pattern = re.compile(r"--\s*GameId:\s*(\d+)")

# Data structure to hold PlaceId and GameId mappings
games_data = {
    "placeScripts": {},
    "gameIdScripts": {}
}

# Iterate over files in the scripts directory
for filename in os.listdir(scripts_dir):
    if filename.endswith(".lua") or filename.endswith(".luau"):
        script_path = os.path.join(scripts_dir, filename)
        with open(script_path, "r") as file:
            content = file.read()

            # Extract PlaceId and GameId from the script
            place_id_match = place_id_pattern.search(content)
            game_id_match = game_id_pattern.search(content)

            # Construct the full URL for the script
            script_url = f"{base_url}/{filename}"

            # If a PlaceId is found, add it to the placeScripts mapping
            if place_id_match:
                place_id = place_id_match.group(1)
                games_data["placeScripts"][place_id] = script_url

            # If a GameId is found, add it to the gameIdScripts mapping
            if game_id_match:
                game_id = game_id_match.group(1)
                games_data["gameIdScripts"][game_id] = script_url

# Write the updated games.json file
with open(output_file, "w") as json_file:
    json.dump(games_data, json_file, indent=4)

print("games.json has been updated!")
