-- Config.luau
local Config = {
    githubUsername = "HoyoGey",   -- Your GitHub username
    githubRepo = "Script",        -- Your repository name
    githubBranch = "main",        -- The branch of your repository to fetch scripts from
    scriptPath = "src/scripts"    -- The path to the folder where your scripts are stored
}

-- Function to construct the URL for a script file
function Config.getScriptUrl(scriptName)
    -- Ensure the script name is a string and not empty
    assert(type(scriptName) == "string" and #scriptName > 0, "Invalid script name provided")

    -- Construct the URL for the script
    return string.format("https://raw.githubusercontent.com/%s/%s/refs/heads/%s/%s/%s.luau",
        Config.githubUsername,
        Config.githubRepo,
        Config.githubBranch,
        Config.scriptPath,
        scriptName
    )
end

return Config
