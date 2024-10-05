local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/config.luau"))() -- Load the Config module
local HttpService = game:GetService("HttpService") -- HttpService for fetching the JSON

-- Load requireL from an external file and initialize it with Config
loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/requireL.luau"))()(Config)

local placeId = game.PlaceId
local gameId = game.GameId

local GameScripts = tableSupportedGames()

-- local jsonContent = requireL("games.json")
-- warn("json content:", jsonContent)
-- HttpService:JSONDecode(jsonContent)

-- Function to load and run the correct script
local function runScript()
    local gameUrl

    -- Look for the matching placeId script
    for id, url in pairs(GameScripts.placeScripts) do
        if id == placeId then
            gameUrl = url
            print("PlaceId script found for place:", placeId, "URL:", gameUrl)
            break -- Exit the loop once the script is found
        end
    end

    -- If no placeId script is found, check for gameId script
    if not gameUrl then
        for id, url in pairs(GameScripts.gameIdScripts) do
            if id == gameId then
                gameUrl = url
                print("GameId script found for game:", gameId, "URL:", gameUrl)
                break -- Exit the loop once the script is found
            end
        end
    end

    print(gameUrl)
    if gameUrl then
        print("yay")
    else
        warn("Nothing")
    end
end

-- Run the appropriate script
runScript()