-- Config.lua
local Config = {}

-- Your GitHub username
Config.githubUsername = "HoyoGey"

-- Your repository name
Config.githubRepo = "Script"

-- The branch of your repository to fetch scripts from
Config.githubBranch = "main" -- Or replace with the appropriate branch name

-- The path to the folder where your scripts are stored in the repository
Config.scriptPath = "scripts" -- Adjust this if the folder path is different

-- Function to construct the URL for a script file
function Config.getScriptUrl(scriptName)
    return string.format("https://raw.githubusercontent.com/%s/%s/%s/%s/%s.lua",
        Config.githubUsername,
        Config.githubRepo,
        Config.githubBranch,
        Config.scriptPath,
        scriptName
    )
end

return Config
