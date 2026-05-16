-- =============================================
-- ☭ SovietIlya & Danil415k Script Menu Admin Menu ☭
-- Delta Executor | GitHub Loader
-- =============================================

local GITHUB_RAW = "https://raw.githubusercontent.com/SovietIlyaGG/SovietIlya-script/main/"

local function loadModule(name)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(GITHUB_RAW .. name .. ".lua"))()
    end)
    if not success then
        warn("❌ Ошибка загрузки: " .. name)
        return nil
    end
    return result
end

local GUI = loadModule("GUI")
local Functions = loadModule("Functions")

if GUI and Functions then
    GUI:Init(Functions)
    print("✅ SovietIlya & Danil415k Menu загружен!")
end