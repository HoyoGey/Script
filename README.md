Hello Guys its best Loader for ur cool script!

its beta script and he can have some bugs if u found smth say pls to me @next.xrer

how to make auto update games.json?

Create yml file in git repo by this path `.github/workflows/update_games_json.yml` and in:
```yml
# GitHub Actions workflow to run update_games_json.py and commit changes
name: Update games.json

on:
  push:
    branches:
      - main  # Trigger workflow on pushes to the 'main' branch

permissions:
  contents: write

jobs:
  update-games-json:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout the repository
      - name: Checkout Repository
        uses: actions/checkout@v4

      # Step 2: Set up Python
      - name: Set up Python
        uses: actions/setup-python@v3
        with:
          python-version: "3.10"  # Use Python 3.10 or specify your preferred version

      # Step 3: Install Python Dependencies (if any)
      - name: Install Python Dependencies
        run: |
          python -m pip install --upgrade pip
          if [ -f requirements.txt ]; then pip install -r requirements.txt; fi


      # Step 4: Run the update_games_json.py script
      - name: Run Script to Update games.json
        run: |
          python update_games_json.py

      # Step 5: Commit and Push Changes
      - name: Commit and Push Changes
        run: |
          git config --local user.email "@gmail.com"
          git config --local user.name ""
          git add games.json
          git diff-index --quiet HEAD || git commit -m "Update games.json"
          git push
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```


games.json update by py script what getting from `src/scripts` lua/luau files and check comments on top.
