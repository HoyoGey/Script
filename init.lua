-- init.luau
local GameScripts = require(script:WaitForChild("GameScripts")) -- Load the GameScripts module

local HttpService = game:GetService("HttpService")
local placeId = game.PlaceId
local gameId = game.GameId

-- Function to fetch and execute the script from GitHub
local function loadAndRunScriptFromUrl(url)
    local success, result = pcall(function()
        local scriptContent = HttpService:HttpGet(url) -- Fetch the script content from GitHub
        local scriptFunction = loadstring(scriptContent) -- Load the script as a function
        return scriptFunction
    end)

    if success and result then
        result() -- Run the loaded script
    else
        warn("Failed to load or run script from URL: " .. url)
    end
end

-- Function to load and run the correct script
local function runScript()
    if GameScripts.placeScripts[placeId] then
        local url = Config.getScriptUrl(GameScripts.placeScripts[placeId]) -- Get the script URL
        loadAndRunScriptFromUrl(url)
    elseif GameScripts.gameIdScripts[gameId] then
        local url = Config.getScriptUrl(GameScripts.gameIdScripts[gameId]) -- Get the script URL
        loadAndRunScriptFromUrl(url)
    else
        print("No script available for this PlaceId/GameId")
    end
end

-- Run the appropriate script
runScript()
