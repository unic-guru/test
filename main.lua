
--// Core
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

--// Files
loadstring(game:HttpGet("https://raw.githubusercontent.com/unic-guru/test/refs/heads/main/esp.lua"))()

--// Build
local Window = Fluent:CreateWindow({
    Title = "NovaHUB " .. Fluent.Version,
    SubTitle = "by 5n e seus camaradas",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 400),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.M
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Tabs.Main:AddParagraph({
        Title = "Official Discord Server",
        Content = "Join discord.gg/XXXXXX for early access to the latest updates, exclusive features, and future releases of this script."
    })

    --// Role ESP
    local Toggle = Tabs.Main:AddToggle("Roles ESP", {Title = "Toggle", Default = true })

    Toggle:OnChanged(function()
        NOVA_ESP_CONFIG.SetActive(Toggle.Value)
    end)

    local Keybind = Tabs.Main:AddKeybind("Keybind", {
        Title = "Toggle ESP",
        Mode = "Toggle",
        Default = "V",
    })

    Keybind:OnChanged(function()
        Togge:SetValue(not Keybind.Value)
    end)

    local MurdererColor = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Murderer Color",
        Default = Color3.new(1, 0, 0)
    })

    MurdererColor:OnChanged(function()
        NOVA_ESP_CONFIG.SetColor("Murderer", MurdererColor.Value)
    end)

    local SheriffColor = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Sheriff Color",
        Default = Color3.new(0, 0, 1)
    })

    SheriffColor:OnChanged(function()
        NOVA_ESP_CONFIG.SetColor("Sheriff", SheriffColor.Value)
    end)

    local InnocentColor = Tabs.Main:AddColorpicker("Colorpicker", {
        Title = "Innocent Color",
        Default = Color3.new(1, 1, 1)
    })

    InnocentColor:OnChanged(function()
        NOVA_ESP_CONFIG.SetColor("Innocent", InnocentColor.Value)
    end)
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

SaveManager:IgnoreThemeSettings()

InterfaceManager:SetFolder("NovaHUB")
SaveManager:SetFolder("NovaHUB/Murder-Mystery-2")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()
