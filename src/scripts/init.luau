-- Automatically populate GameScripts from a JSON file on GitHub
print("started - src/scripts/init")

local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/giturl.luau"))() -- Load the Config module
-- local requireL = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/requireL.luau"))()(Config) -- Load requireL with Config
local HttpService = game:GetService("HttpService") -- HttpService for fetching the JSON
local GameScripts = {}

-- Fetch and parse the JSON file from GitHub using requireL
local function loadGameScripts()
    local success, result = pcall(function()
        local jsonContent = requireL("games.json") -- Use requireL to fetch the JSON content
        warn("json content:", jsonContent)
        return HttpService:JSONDecode(jsonContent) -- Parse the JSON into a Lua table
    end)

    if success and result then
        GameScripts = result
        print(GameScripts)
        -- GameScripts.placeScripts = result.placeScripts -- Set PlaceId scripts
        -- GameScripts.gameIdScripts = result.gameIdScripts -- Set GameId scripts
    else
        warn("Failed to load or parse games.json: " .. tostring(result))
    end
end

-- Load the scripts from the JSON file
loadGameScripts()

return GameScripts
