local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:SetFont("rbxassetid://12187371840")

WindUI:AddTheme({
    Name = "Vyntric Dark Red",
    Accent = "#7b1e1e",       -- Deep dark red for accents
    Outline = "#ffffff",      -- White outline for clarity
    Text = "#ffffff",         -- White text
    Placeholder = "#b85c5c",  -- Muted red for placeholders
    Background = "#1a0d0d",   -- Very dark red/blackish for background
    Button = "#8b2c2c",       -- Dark red for buttons
    Icon = "#d46a6a",         -- Light red/pink for icons
})

local Window = WindUI:CreateWindow({
    Title = "Vyntric Hub",
    Icon = "satellite",
    Author = "Dead Rails | by ttvkaiser and Exv_",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Vyntric Dark Red",
    SideBarWidth = 200,
    Background = "", -- rbxassetid only
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
            print("clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "Vyntric Hub",
    Icon = "satellite",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("1a0d0d"), 
        Color3.fromHex("7b1e1e")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = false,
})

local Dialog = Window:Dialog({
    Icon = "satellite",
    Title = "Thanks for Using\nDead Rails | Vyntric Hub",
    Content = "Join our discord for more scripts!",
    Buttons = {
        {
            Title = "Continue",
            Callback = function()
                print("Confirmed!")
            end,
        },
    },
})

local Home = Window:Tab({
    Title = "Home",
    Icon = "house",
    Locked = false,
})
local Main = Window:Tab({
    Title = "Main",
    Icon = "align-justify",
    Locked = false,
})
local ESP = Window:Tab({
    Title = "ESP",
    Icon = "ratio",
    Locked = false,
})
local Teleport = Window:Tab({
    Title = "Home",
    Icon = "tree-palm",
    Locked = false,
})
local Misc = Window:Tab({
    Title = "Misc",
    Icon = "command",
    Locked = false,
})
local Credits = Window:Tab({
    Title = "Credits",
    Icon = "credit-card",
    Locked = false,
})

Window:SelectTab(1) -- Number of Tab

local DiscordInviteSection = Home:Section({ 
    Title = "Discord Invite",
    TextXAlignment = "Left",
    TextSize = 19, -- Default Size
})

local Button = Home:Button({
    Title = "Copy Discord Invite",
    Desc = "Click to copy invite to clipboard",
    Locked = false,
    Callback = function()
        local inviteLink = "https://discord.gg/G6q7FJCyc8"
        if setclipboard then
            setclipboard(inviteLink)
            print("Copied to clipboard:", inviteLink)
        else
            warn("Clipboard function not supported on this executor.")
        end
    end
})

local LocalPlayerSection = Home:Section({ 
    Title = "Local Player Configurations",
    TextXAlignment = "Left",
    TextSize = 19, -- Default Size
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local noclip = false
local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

LocalPlayer.CharacterAdded:Connect(function(char)
    currentCharacter = char
end)

local NoClipToggle = Home:Toggle({
    Title = "No Clip",
    Desc = "",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        noclip = state
        print("No Clip: " .. tostring(state))
    end
})

RunService.Stepped:Connect(function()
    if noclip and currentCharacter then
        for _, v in pairs(currentCharacter:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

local AutoSection = Main:Section({ 
    Title = "Auto",
    TextXAlignment = "Left",
    TextSize = 19, -- Default Size
})

local AutoBondToggle = Main:Toggle({
    Title = "Auto Bond",
    Desc = "Collects all bonds",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

local AutoWinToggle = Main:Toggle({
    Title = "Auto Win",
    Desc = "Make sure you waited 10 minutes then use!",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

local AutoCollectItemsSection = Main:Section({ 
    Title = "Auto Collect Items",
    TextXAlignment = "Left",
    TextSize = 19, -- Default Size
})

local SelectItemDropdown = Main:Dropdown({
    Title = "Select Item",
    Values = { "Bonds", "Junk", "Snake Oil" },
    Value = "Choose..",
    Callback = function(option) 
        print("Category selected: " .. option) 
    end
})

local CollectItemToggle = Main:Toggle({
    Title = "Collect Items",
    Desc = "This may show 'Gameplay Paused' just wait until it has collect everything!",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DisplayUISection = Main:Section({ 
    Title = "Added UI's [BETA]",
    TextXAlignment = "Left",
    TextSize = 19,
})

local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 200, 0, 30)
timeLabel.Position = UDim2.new(0, 10, 0, 100)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timeLabel.TextXAlignment = Enum.TextXAlignment.Left
timeLabel.TextSize = 18
timeLabel.Font = Enum.Font.SourceSans
timeLabel.Visible = false
timeLabel.Parent = PlayerGui

local waitLabel = timeLabel:Clone()
waitLabel.Position = UDim2.new(0, 10, 0, 130)
waitLabel.Parent = PlayerGui
waitLabel.Visible = false

local ShowTimeToggle = Main:Toggle({
    Title = "Show Time",
    Desc = "This shows how long you been in the server",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        if state then
            local startTime = tick()
            timeLabel.Visible = true
            task.spawn(function()
                while ShowTimeToggle.Value do
                    local elapsed = tick() - startTime
                    local minutes = math.floor(elapsed / 60)
                    local seconds = math.floor(elapsed % 60)
                    timeLabel.Text = string.format("Time in server: %dm, %ds", minutes, seconds)
                    task.wait(1)
                end
                timeLabel.Visible = false
            end)
        else
            timeLabel.Visible = false
        end
    end
})

local WaitTimeToggle = Main:Toggle({
    Title = "Wait Time",
    Desc = "This shows the time left until you can press the lever",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        if state then
            local joinTime = tick() - 300
            waitLabel.Visible = true
            task.spawn(function()
                while WaitTimeToggle.Value do
                    local timeSinceJoin = tick() - joinTime
                    local countdown = 600 - timeSinceJoin
                    local minutes = math.max(math.floor(countdown / 60), 0)
                    local seconds = math.max(math.floor(countdown % 60), 0)
                    waitLabel.Text = string.format("Time left: %dm, %ds", minutes, seconds)
                    task.wait(1)
                end
                waitLabel.Visible = false
            end)
        else
            waitLabel.Visible = false
        end
    end
})

local MoneyShowerToggle = Main:Toggle({
    Title = "Money",
    Desc = "This will show how much money you have",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

local PlayerESPSection = ESP:Section({ 
    Title = "Player ESP",
    TextXAlignment = "Left",
    TextSize = 19,
})

local ESPColor = Color3.fromRGB(0, 255, 0)

local PlayerESPColorpicker = ESP:Colorpicker({
    Title = "Choose Color of Player ESP",
    Desc = "Change the color of Player ESP",
    Default = ESPColor,
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        ESPColor = color
        print("ESP color set to: " .. tostring(color))
    end
})

local ESPConnection

local PlayerESPToggle = ESP:Toggle({
    Title = "Player ESP",
    Desc = "You can change the ESP Color with the colorpicker above",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        print("Toggle Activated: " .. tostring(state))

        if state then
            ESPConnection = game:GetService("RunService").RenderStepped:Connect(function()
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if not player.Character:FindFirstChild("ESPHighlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ESPHighlight"
                            highlight.Adornee = player.Character
                            highlight.FillColor = ESPColor
                            highlight.FillTransparency = 0.5
                            highlight.OutlineColor = Color3.new(0, 0, 0)
                            highlight.OutlineTransparency = 0
                            highlight.Parent = player.Character
                        else
                            player.Character.ESPHighlight.FillColor = ESPColor
                        end
                    end
                end
            end)
        else
            if ESPConnection then
                ESPConnection:Disconnect()
                ESPConnection = nil
            end

            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("ESPHighlight") then
                    player.Character.ESPHighlight:Destroy()
                end
            end
        end
    end
})

local ItemsESPSection = ESP:Section({ 
    Title = "Items ESP",
    TextXAlignment = "Left",
    TextSize = 19,
})

local ESPColor = Color3.fromRGB(255, 0, 0)

local ItemESPColorpicker = ESP:Colorpicker({
    Title = "Choose Color of Item ESP",
    Desc = "Change the color of Item ESP",
    Default = ESPColor,
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        ESPColor = color
        print("ESP color set to: " .. tostring(color))
    end
})

local ESPConnection

local ItemESPToggle = ESP:Toggle({
    Title = "Item ESP",
    Desc = "Shows ESP on Newspaper and Snake Oil items",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        print("Toggle Activated: " .. tostring(state))

        local function createItemESP(part)
            if part and not part:FindFirstChild("ESPHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.Adornee = part
                highlight.FillColor = ESPColor
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.new(0, 0, 0)
                highlight.OutlineTransparency = 0
                highlight.Parent = part

                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPNameTag"
                billboard.Adornee = part
                billboard.Size = UDim2.new(0, 100, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = part

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = ESPColor
                label.TextStrokeTransparency = 0
                label.Text = part.Name
                label.Font = Enum.Font.SourceSansBold
                label.TextScaled = true
                label.Parent = billboard
            else
                local highlight = part:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight.FillColor = ESPColor
                end

                local billboard = part:FindFirstChild("ESPNameTag")
                if billboard and billboard:FindFirstChildOfClass("TextLabel") then
                    billboard.TextLabel.TextColor3 = ESPColor
                end
            end
        end

        if state then
            ESPConnection = game:GetService("RunService").RenderStepped:Connect(function()
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name == "Newspaper" or part.Name == "Snake Oil") then
                        createItemESP(part)
                    end
                end
            end)
        else
            if ESPConnection then
                ESPConnection:Disconnect()
                ESPConnection = nil
            end

            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part:FindFirstChild("ESPHighlight") then
                        part.ESPHighlight:Destroy()
                    end
                    if part:FindFirstChild("ESPNameTag") then
                        part.ESPNameTag:Destroy()
                    end
                end
            end
        end
    end
})

local ESPColor = Color3.fromRGB(255, 0, 0)

local EnemyESPColorpicker = ESP:Colorpicker({
    Title = "Choose Color of Enemy ESP",
    Desc = "Change the color of Enemy ESP",
    Default = ESPColor,
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        ESPColor = color
        print("Enemy ESP color set to: " .. tostring(color))
    end
})

local ESPConnection

local EnemyESPToggle = ESP:Toggle({
    Title = "Enemy ESP",
    Desc = "Shows ESP on Runner zombies",
    Icon = "",
    Type = "Toggle",
    Default = false,
    Callback = function(state)
        print("Enemy ESP Activated: " .. tostring(state))

        local function applyESP(model)
            if not model:FindFirstChild("ESPHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.Adornee = model
                highlight.FillColor = ESPColor
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.new(0, 0, 0)
                highlight.OutlineTransparency = 0
                highlight.Parent = model

                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESPNameTag"
                billboard.Adornee = model
                billboard.Size = UDim2.new(0, 100, 0, 30)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Parent = model

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = ESPColor
                label.TextStrokeTransparency = 0
                label.Text = model.Name
                label.Font = Enum.Font.SourceSansBold
                label.TextScaled = true
                label.Parent = billboard
            else
                model.ESPHighlight.FillColor = ESPColor
                local tag = model:FindFirstChild("ESPNameTag")
                if tag and tag:FindFirstChildOfClass("TextLabel") then
                    tag.TextLabel.TextColor3 = ESPColor
                end
            end
        end

        if state then
            ESPConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local enemiesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")?
                    :FindFirstChild("Entities")?
                    :FindFirstChild("Zombies")?
                    :FindFirstChild("Runner")

                if enemiesFolder then
                    for _, enemy in pairs(enemiesFolder:GetChildren()) do
                        if enemy:IsA("Model") and enemy.Name == "Model_Runner" then
                            applyESP(enemy)
                        end
                    end
                end
            end)
        else
            if ESPConnection then
                ESPConnection:Disconnect()
                ESPConnection = nil
            end

            local enemiesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")?
                :FindFirstChild("Entities")?
                :FindFirstChild("Zombies")?
                :FindFirstChild("Runner")

            if enemiesFolder then
                for _, enemy in pairs(enemiesFolder:GetChildren()) do
                    if enemy:IsA("Model") then
                        if enemy:FindFirstChild("ESPHighlight") then
                            enemy.ESPHighlight:Destroy()
                        end
                        if enemy:FindFirstChild("ESPNameTag") then
                            enemy.ESPNameTag:Destroy()
                        end
                    end
                end
            end
        end
    end
})

local CreditsParagraph = Credits:Paragraph({
    Title = "Special Thanks to ttvkaiser & Exv_ for scripting this!",
    Desc = "Your support and contributions made this project possible.",
    Color = "Red",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "shield-check",
            Title = "Follow Us On Tiktok",
            Callback = function() 
                print("Follow button clicked!") 
                       local tiktokLink = "tiktok.com/@vyntric.hub.productions"
                          if setclipboard then
                          setclipboard(tiktokLink)
                        print("Copied to clipboard:", tiktokLink)
                         else
                          warn("Clipboard function not supported on this executor.")
                  end
            end,
        }
    }
})
