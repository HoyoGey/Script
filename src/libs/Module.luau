--[[ 
    SirHub/NextHub Module
    Version: Beta 1.1.3
    Description: Core utility module for SirHub/HextHub functionality
]]

local module = {
    Config = {
        Version = '<font transparency="0.5">1.1.3!</font>',
    },
    Settings = {}
}

-- Services
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoyoGey/Script/refs/heads/main/src/libs/UI.luau"))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- Constants
local LOCAL_PLAYER = Players.LocalPlayer
local SETTINGS_BASE_PATH = "Sirhub/Settings"

-- Utility Functions
function module.SendChatNotification(text)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[SirHub]: " .. text,
        Color = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size24
    })
end

function module.IsNumber(text)
    return tonumber(text) ~= nil
end

function module.ShowNotification(title, text, duration)
    Library.Notification({
        Title = title,
        Content = text,
        Delay = duration
    })
end

function module.SafeExecute(func, funcName)
    local success, result = pcall(func)
    if not success then
        module.ShowNotification(funcName and (funcName .. " Error") or "Error", result, 10)
        return nil
    end
    return result
end

function module.GetVersion()
    return module.Config.Version
end

-- Time Formatting Functions
function module.FormatTimeDetailed(timeInSeconds)
    local seconds = timeInSeconds % 60
    local minutes = math.floor(timeInSeconds / 60) % 60
    local hours = math.floor(timeInSeconds / 3600) % 24
    local days = math.floor(timeInSeconds / 86400)

    return string.format("%02d:%02d:%02d:%02d", hours, minutes, seconds, days)
end

function module.FormatTimeReadable(timeInSeconds)
    local seconds = timeInSeconds % 60
    local minutes = math.floor(timeInSeconds / 60) % 60
    local hours = math.floor(timeInSeconds / 3600) % 24
    local days = math.floor(timeInSeconds / 86400)

    return string.format("%02dd %02dh %02dm %02ds", days, hours, minutes, seconds)
end

function module.FormatPercentage(options)
    local number = options.number or 2
    local minimum = options.minimum or 1
    local maximum = options.maximum or 3
    
    number = math.max(minimum, math.min(number, maximum))
    local percentage = (number - minimum) / (maximum - minimum) * 100
    percentage = math.floor(percentage * 100 + 0.5) / 100
    
    return string.format("%.2f%%", percentage)
end

-- File System Functions
local function FileExists(filePath)
    local success = pcall(readfile, filePath)
    return success
end

local function EnsureFolder(folderPath)
    if not isfolder(folderPath) then
        local success, error = pcall(makefolder, folderPath)
        if not success then
            error("Failed to create folder: " .. folderPath .. ". Error: " .. error)
        end
    end
end

local function SaveSettingsToFile(settings, filename)
    local filePath = SETTINGS_BASE_PATH .. "/" .. filename .. ".json"
    EnsureFolder(SETTINGS_BASE_PATH)
    writefile(filePath, HttpService:JSONEncode(settings))
end

local function LoadSettingsFromFile(filename)
    local filePath = SETTINGS_BASE_PATH .. "/" .. filename .. ".json"
    if FileExists(filePath) then
        return HttpService:JSONDecode(readfile(filePath))
    end
    return nil
end

-- Table Utility Functions
function module.TableUtility()
    local TableUtil = {}

    function TableUtil.DeepCopy(t)
        assert(type(t) == "table", "First argument must be a table")
        local copy = table.create(#t)
        for k, v in pairs(t) do
            copy[k] = type(v) == "table" and TableUtil.DeepCopy(v) or v
        end
        return copy
    end

    function TableUtil.Print(tbl, label, deepPrint)
        assert(type(tbl) == "table", "First argument must be a table")
        assert(label == nil or type(label) == "string", "Second argument must be a string or nil")

        label = label or "TABLE"
        local output = {}
        local indent = " - "

        local function AddLine(text, level)
            table.insert(output, indent:rep(level) .. text .. "\n")
        end

        local function CompareKeys(a, b)
            return tostring(a.k) < tostring(b.k)
        end

        local function PrintTable(t, level, header)
            AddLine(header .. ":", level - 1)
            local nonTables, tables, maxKeyLength = {}, {}, 0

            for k, v in pairs(t) do
                local entry = { k = k, v = v }
                if type(v) == "table" then
                    table.insert(tables, entry)
                else
                    entry.v = "[" .. typeof(v) .. "] " .. tostring(v)
                    table.insert(nonTables, entry)
                end
                maxKeyLength = math.max(maxKeyLength, #tostring(k) + 1)
            end

            table.sort(nonTables, CompareKeys)
            table.sort(tables, CompareKeys)

            for _, entry in ipairs(nonTables) do
                local padding = (" "):rep(maxKeyLength - #tostring(entry.k))
                AddLine(tostring(entry.k) .. ":" .. padding .. entry.v, level)
            end

            if deepPrint then
                for _, entry in ipairs(tables) do
                    local padding = (" "):rep(maxKeyLength - #tostring(entry.k))
                    PrintTable(entry.v, level + 1, tostring(entry.k) .. padding .. " [Table]")
                end
            else
                for _, entry in ipairs(tables) do
                    local padding = (" "):rep(maxKeyLength - #tostring(entry.k))
                    AddLine(tostring(entry.k) .. ":" .. padding .. "[Table]", level)
                end
            end
        end

        PrintTable(tbl, 1, label)
        local result = table.concat(output)
        print(result)
        return result
    end

    function TableUtil.Reverse(tbl)
        local length = #tbl
        local reversed = table.create(length)
        for i = 1, length do
            reversed[i] = tbl[length - i + 1]
        end
        return reversed
    end

    function TableUtil.Shuffle(tbl)
        assert(type(tbl) == "table", "First argument must be a table")
        local rng = Random.new()
        for i = #tbl, 2, -1 do
            local j = rng:NextInteger(1, i)
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
    end

    function TableUtil.IsEmpty(tbl)
        return next(tbl) == nil
    end

    return TableUtil
end

-- Settings Management
function module.LoadSettings(settings, settingsName)
    module.Settings = settings
    local settingsPath = SETTINGS_BASE_PATH .. "/" .. settingsName
    EnsureFolder(settingsPath)
    
    local loadedSettings = LoadSettingsFromFile(settingsName)
    if loadedSettings then
        for key, value in pairs(loadedSettings) do
            module.Settings[key] = value
        end
    end
end

function module.SaveSettings(settingsName)
    SaveSettingsToFile(module.Settings, settingsName)
end

-- UI Components
function module.AddSettingsSection(Main)
    local SettingsTab = Main.AddTab("Settings")
    
    -- General Settings Section
    local GeneralSettings = SettingsTab.AddSection("Settings")
    
    GeneralSettings.AddBind({
        Name = "Toggle GUI Bind",
        Default = Enum.KeyCode.LeftControl,
        Callback = function()
            if shared.NapkinGUILibrary then
                shared.NapkinGUILibrary.Enabled = not shared.NapkinGUILibrary.Enabled
            end
        end
    })
    
    return SettingsTab
end

function module.AddCreditsSection(tab)
    local credits = tab.AddSection("Credits")
    
    local discordLink = "https://discord.gg/Pyeqat359G"
    
    local creditButtons = {
        {
            Name = "Script Made by SirHub and NextHub",
            Callback = function()
                setclipboard(discordLink)
                module.ShowNotification("Copied to clipboard", "Link to discord server copied.", 10)
            end
        },
        {
            Name = "Discord Server",
            Callback = function()
                setclipboard(discordLink)
                module.ShowNotification("Copied to clipboard", "Link to discord server copied.", 10)
            end
        },
        {
            Name = "UI Lib is brought to you by AeroX 2022 made by Dawid",
            Callback = function() end
        },
        {
            Name = "Dawid#7205 - UI Library Maker",
            Callback = function() end
        },
        {
            Name = "hrzn#1234 - UI Library Owner",
            Callback = function() end
        }
    }
    
    for _, button in ipairs(creditButtons) do
        credits.AddButton(button)
    end
end

return Library, module
