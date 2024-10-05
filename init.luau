print("eh")
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/config.luau"))() -- Load the Config module
local HttpService = game:GetService("HttpService") -- HttpService for fetching the JSON

getgenv().requireL = function(path)
    -- Ensure the path is a string
    assert(type(path) == "string", "invalid argument #1 to 'requireL' (string expected, got " .. type(path) .. ")", 2)

    warn("requireL used.")

    -- Construct the URL to fetch the script from GitHub
    local url = string.format("https://raw.githubusercontent.com/%s/%s/refs/heads/%s/%s",
        Config.githubUsername, -- 1
        Config.githubRepo,     -- 2
        Config.githubBranch,   -- 3
        path                   -- 4
    )

    -- Make the request to the URL
    local response = request({Url = url; Method = "GET";})
    print("Get Request on Url:", url)

    -- Check if the response is successful
    if response.Success then
        return response.Body -- Return the body of the response
    else
        error("Failed to fetch script from: " .. url .. " | Error: " .. response.StatusCode)
    end
end

getgenv().tableSupportedGames = function()
    warn("tableSupportedGames used.")
    local jsonContent = requireL("games.json") -- Use requireL to fetch the JSON conten
    warn("json content:", jsonContent)
    return HttpService:JSONDecode(jsonContent) -- Parse the JSON into a Lua table
end

local placeId = game.PlaceId
local gameId = game.GameId

-- local jsonContent = requireL("games.json")
-- warn("json content:", jsonContent)
-- local GameScripts = HttpService:JSONDecode(jsonContent)

local GameScripts = tableSupportedGames()

_G.gameUrl = ""

-- Function to load and run the correct script
local function runScript()
    -- Look for the matching placeId script
    for id, url in pairs(GameScripts.placeScripts) do
        if id == placeId then
            _G.gameUrl = url
            print("PlaceId script found for place:", placeId, "URL:", gameUrl)
        end
    end

    -- If no placeId script is found, check for gameId script
    if not _G.gameUrl then
        for id, url in pairs(GameScripts.gameIdScripts) do
            if id == gameId then
                _G.gameUrl = url
                print("GameId script found for game:", gameId, "URL:", gameUrl)
            end
        end
    end

    print(_G.gameUrl )
    if _G.gameUrl then
        print("yay")
    else
        warn("Nothing")
    end
end

-- Run the appropriate script
runScript()
print("wqhy")