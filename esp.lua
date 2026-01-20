--// Core
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InputService = game:GetService("UserInputService")

--// Config
getgenv().NOVA_ESP_CONFIG = {} :: {
  SetActive: (boolean) -> nil,
  SetColor: (Color3) -> nil,
  SetKeybind: (Enum.KeyCode) -> nil,
}

--// Globals
local keybind = Enum.KeyCode.V
local startEvent = ReplicatedStorage.Remotes.Gameplay.RoundStart
local roleColors = {
    ["Innocent"] = Color3.new(1,1,1),
    ["Murderer"] = Color3.new(1,0,0),
    ["Sheriff"] = Color3.new(0,0,1),
}
local active = true

--// Methods
local function getRole(plr)
    local character = plr.Character
    local backpack = plr:FindFirstChild("Backpack")

    if not character or not backpack then return "Innocent" end

    if character:FindFirstChild("Knife") or backpack:FindFirstChild("Knife") then
        return "Murderer"
    elseif character:FindFirstChild("Gun") or backpack:FindFirstChild("Gun") then
        return "Sheriff"
    else
        return "Innocent"
    end
end

--// Callbacks
local function loadCharacter(chr)
    local highlight = Instance.new("Highlight")
    highlight.Name = "NovaESP_Highlight"
    highlight.FillTransparency = 1
    highlight.OutlineColor = roleColors[getRole(Players:GetPlayerFromCharacter(chr))]
    highlight.Parent = chr

    chr.ChildAdded:Connect(function(child)
        if child.Name == "Gun" then
            chr["NovaESP_Highlight"].OutlineColor = roleColors["Sheriff"]
        end
    end)
end

local function loadPlayer(plr)
    if plr.Character then
        loadCharacter(plr.Character)
    end

    plr.CharacterAdded:Connect(function(chr)
        loadCharacter(chr)
    end)
end

--// Config Methods
function NOVA_ESP_CONFIG.SetActive(state)
    active = state

    for _, plr in Players:GetPlayers() do
        local char = plr.Character
        if not char then continue end

        char["NovaESP_Highlight"].Enabled = active
    end
end
function NOVA_ESP_CONFIG.SetColor(role, color)
    roleColors[role] = color

    for _, plr in Players:GetPlayers() do
        local char = plr.Character
        if not char then continue end

        char["NovaESP_Highlight"].OutlineColor = roleColors[getRole(plr)]
    end
end
function NOVA_ESP_CONFIG.SetKeybind(_keybind)
    keybind = _keybind
end

--// Connections
Players.PlayerAdded:Connect(function(plr)
    loadPlayer(plr)
end)

startEvent.OnClientEvent:Connect(function(_, data)
    for username, info in data do
        local player = Players:FindFirstChild(username)
        if not player then continue end

        player.Character["NovaESP_Highlight"].OutlineColor = roleColors[info.Role]
    end
end)

InputService.InputBegan:Connect(function(kc, chatting)
    if chatting then return end

    if kc.KeyCode == keycode then
        NOVA_ESP_CONFIG.SetActive(not active)
    end
end)

--// Started
for _, plr in Players:GetPlayers() do
    loadPlayer(plr)
end
