Hello Guys its best Loader for ur cool script!

its beta script and he can have some bugs if u found smth say pls to me @next.xrer

how to make auto update games.json?

Create yml file in git repo by this path `.github/workflows/update_games_json.yml` and in:
```yml
name: Update games.json

on:
  push:
    branches:
      - main  # or any branch you want to trigger the update

jobs:
  update-json:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.x'

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip

      - name: Run update_games_json.py script
        run: |
          python update_games_json.py

      - name: Commit and push changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add games.json
          git commit -m "Update games.json"
          git push
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```


games.json update by py script what getting from `src/scripts` lua/luau files and check comments on top.