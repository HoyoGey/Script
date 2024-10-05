print("started - /init")

local GameScripts = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/scripts/init.luau"))() -- Load the GameScripts module
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/giturl.luau"))() -- Load the Config module

-- Load requireL from an external file and initialize it with Config
loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/requireL.luau"))()(Config)

local placeId = game.PlaceId
local gameId = game.GameId

-- Function to fetch and execute the script from GitHub
local function loadAndRunScriptFromUrl(url)
    print("Fetching script from URL:", url) -- Print the URL here for debugging
    local success, result = pcall(function()
        -- Fetch the script content from GitHub
        local scriptContent = game:HttpGet(url) -- Ensure the script content is retrieved successfully
        if not scriptContent or scriptContent == "" then
            error("Script content is empty or failed to load.") -- Add more explicit error handling
        end
        local scriptFunction = loadstring(scriptContent) -- Load the script as a function
        return scriptFunction -- Return the function, don't run it here yet
    end)

    if success and result then
        pcall(result) -- Run the loaded script with another pcall to prevent crashes
        print("Script executed successfully.") -- Success message
    else
        warn("Failed to load or run script from URL: " .. url)
        warn(result) -- This will give the error details if it fails
    end
end

-- Function to load and run the correct script
local function runScript()
    if GameScripts.placeScripts[placeId] then
        local gameUrl = GameScripts.placeScripts[placeId] -- Get the script URL
        print("PlaceId script found for place:", placeId, "URL:", gameUrl) -- Added debugging print
        loadAndRunScriptFromUrl(gameUrl)
    elseif GameScripts.gameIdScripts[gameId] then
        local gameUrl = GameScripts.gameIdScripts[gameId] -- Get the script URL
        print("GameId script found for game:", gameId, "URL:", gameUrl) -- Added debugging print
        loadAndRunScriptFromUrl(gameUrl)
    else
        warn("No script available for this PlaceId/GameId")
    end
end

-- Run the appropriate script
runScript()