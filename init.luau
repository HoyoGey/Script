print("started - /init")
local GameScripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/scripts/init.luau"))() -- Load the GameScripts module
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/giturl.luau"))() -- Load the Config module

-- Load requireL from an external file and initialize it with Config
loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/requireL.luau"))()(Config)

local placeId = game.PlaceId
local gameId = game.GameId

-- Function to fetch and execute the script from GitHub
local function loadAndRunScriptFromUrl(url)
    local success, result = pcall(function()
        local scriptContent = requireL(url) -- Fetch the script content from GitHub
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
