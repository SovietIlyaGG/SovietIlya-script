-- =============================================
-- Main.lua - ★ Mod Menu By IlyaHacker ★
-- =============================================

local GITHUB_RAW = "https://raw.githubusercontent.com/SovietIlyaGG/SovietIlya-script/main/"

local function loadModule(name)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(GITHUB_RAW .. name .. ".lua"))()
    end)
    if not success then
        warn("Ошибка: " .. name)
        return nil
    end
    return result
end

local GUI = loadModule("GUI")
local Functions = loadModule("Functions")

if GUI and Functions then
    GUI:Init(Functions)
    print("★ Mod Menu By IlyaHacker Loaded!")
end