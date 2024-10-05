-- Automatically populate GameScripts from a JSON file on GitHub
print("started - src/scripts/init")

local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/giturl.luau"))() -- Load the Config module
local HttpService = game:GetService("HttpService") -- HttpService for fetching the JSON
local GameScripts = {}

-- URL to the games.json file in your GitHub repository
local jsonUrl = string.format("https://raw.githubusercontent.com/%s/%s/refs/heads/%s/%s/games.json",
    Config.githubUsername,
    Config.githubRepo,
    Config.githubBranch,
    Config.scriptPath
)

-- Fetch and parse the JSON file from GitHub
local function loadGameScripts()
    local success, result = pcall(function()
        local jsonContent = print(game:HttpGet(jsonUrl)) -- ty Frost Im Just Dumb:(
        -- local jsonContent = request({Url = jsonUrl; Method = "GET"}.Body) -- Correctly using HttpService to fetch the JSON content
        warn("json url:", jsonUrl)
        warn("json content:", jsonContent)
        return HttpService:JSONDecode(jsonContent) -- Parse the JSON into a Lua table
    end)

    if success and result then
        GameScripts.placeScripts = result.placeScripts -- Set PlaceId scripts
        GameScripts.gameIdScripts = result.gameIdScripts -- Set GameId scripts
    else
        warn("Failed to load or parse games.json: " .. tostring(result))
    end
end

-- Load the scripts from the JSON file
loadGameScripts()

return GameScripts
