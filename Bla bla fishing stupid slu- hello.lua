local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()
 
local Window = Library:CreateWindow{
    Title = `Nebula Hub | Game: Fisch | Version [v.beta]`,
    SubTitle = "by ttvkaiser",
    TabWidth = 160,
    Size = UDim2.fromOffset(1087, 690.5),
    Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(470, 380),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
}

-- Fluent Renewed provides ALL 1544 Lucide 0.469.0 https://lucide.dev/icons/ Icons and ALL 9072 Phosphor 2.1.0 https://phosphoricons.com/ Icons for the tabs, icons are optional
local Tabs = {
    Home = Window:CreateTab{
        Title = "Home",
        Icon = "house"
    },
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "align-justify"
    },
    Auto = Window:CreateTab{
        Title = "Automatically",
        Icon = "play"
    },
    Invo = Window:CreateTab{
        Title = "Inventory",
        Icon = "backpack"
    },
    Shop = Window:CreateTab{
        Title = "Shop",
        Icon = "shopping-bag"
    },
    Quests = Window:CreateTab{
        Title = "Quests",
        Icon = "file-question"
    },
    Tele = Window:CreateTab{
        Title = "Teleport",
        Icon = "tree-palm"
    },
    Misc = Window:CreateTab{
        Title = "Miscellaneous",
        Icon = "grid-2x2-x"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local Options = Library.Options

Library:Notify{
    Title = "Nebula Hub",
    Content = "Welcome to Nebula Hub",
    SubContent = "Nebula hub offers a wide varietys of games!", -- Optional
    Duration = 11 -- Set to nil to make the notification not disappear
}

Tabs.Home:AddSection("Discord Server Link")

Tabs.Home:CreateButton({
    Title = "Click to Copy Link",
    Description = "This allows you to join our Discord server and get update pings and more.",
    Callback = function()
        Window:Dialog({
            Title = "Join Our Discord",
            Content = "Would you like to copy the invite link to our Discord server?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        -- Copy to clipboard logic
                        local link = "https://discord.gg/YOUR_INVITE"
                        setclipboard(link)
                        print("Copied Discord link to clipboard.")
                    end
                }
            }
        })
    end
})

Tabs.Home:AddSection("Local Player Configurations")

local speed = 16 -- Default speed

-- Input field
local Input = Tabs.Home:AddInput("Input", {
    Title = "Speed Input",
    Default = tostring(speed),
    Placeholder = "Enter Speed",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            speed = num
            print("Speed set to:", speed)
            if Options.MyToggle.Value then
                applySpeed()
            end
        end
    end
})

-- Toggle
local Toggle = Tabs.Home:AddToggle("MyToggle", {
    Title = "Enable Speed",
    Default = false
})

-- Utility to apply speed
local function applySpeed()
    local player = game.Players.LocalPlayer
    if not player then return end

    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Options.MyToggle.Value and speed or 16
        end
    end
end

-- Toggle handler
Toggle:OnChanged(function()
    print("Toggle changed:", Options.MyToggle.Value)
    applySpeed()
end)

-- Reapply speed on respawn
local player = game.Players.LocalPlayer
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid") -- Ensure humanoid exists
    if Options.MyToggle.Value then
        task.wait(0.1) -- slight delay to ensure stability
        applySpeed()
    end
end)

-- Infinite Jump Toggle
local ToggleInfiniteJump = Tabs.Home:AddToggle("Toggle_InfiniteJump", {Title = "Infinite Jump", Default = false})
ToggleInfiniteJump:OnChanged(function()
    if Options.Toggle_InfiniteJump.Value then
        local UserInputService = game:GetService("UserInputService")
        local Player = game.Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")

        -- Connection to jump input
        _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if Options.Toggle_InfiniteJump.Value then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        print("Infinite Jump enabled")
    else
        if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
        end
        print("Infinite Jump disabled")
    end
end)

-- No Clip Toggle
local ToggleNoClip = Tabs.Home:AddToggle("Toggle_NoClip", {Title = "No Clip", Default = false})
ToggleNoClip:OnChanged(function()
    local RunService = game:GetService("RunService")
    local Player = game.Players.LocalPlayer

    if Options.Toggle_NoClip.Value then
        _G.NoclipConnection = RunService.Stepped:Connect(function()
            local Character = Player.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
        print("No Clip enabled")
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
        print("No Clip disabled")
    end
end)

Tabs.Main:AddSection("Config")

Tabs.Main:CreateButton{
    Title = "Save Position",
    Description = "",
    Callback = function()
        Window:Dialog{
            Title = "Are you sure you wanna save position?",
            Content = "",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        print("Confirmed the dialog.")
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

Tabs.Main:CreateButton{
    Title = "Reset Save Position",
    Description = "",
    Callback = function()
        Window:Dialog{
            Title = "Are you sure that you want to reset your position",
            Content = "",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        print("Confirmed the dialog.")
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

local FarmReelDropdown = Tabs.Main:CreateDropdown("Dropdown", {
    Title = "Farm Reel Mode",
    Values = {"Faster"},
    Multi = false,
    Default = 1,
})

FarmReelDropdown:SetValue("Faster")

FarmReelDropdown:OnChanged(function(Value)
end)

local FarmShakeDropdown = Tabs.Main:CreateDropdown("Dropdown", {
    Title = "Farm Shake Version",
    Values = {"V1", "V2"},
    Multi = false,
    Default = 1,
})

FarmShakeDropdown:SetValue("four")

FarmShakeDropdown:OnChanged(function(Value)
end)

local PreventPerfectToggle = Tabs.Main:CreateToggle("MyToggle", {Title = "Prevent Perfect Catches", Default = false })

PreventPerfectToggle:OnChanged(function()
    print("Toggle changed:", Options.MyToggle.Value)
end)

Options.MyToggle:SetValue(false)

local InstantBobberToggle = Tabs.Main:CreateToggle("MyToggle", {Title = "Instant Bobber", Default = false })

InstantBobberToggle:OnChanged(function()
    print("Toggle changed:", Options.MyToggle.Value)
end)

Options.MyToggle:SetValue(false)

Tabs.Main:AddSection("Farming Fish")

local TeleportModeDropdown = Tabs.Main:CreateDropdown("Dropdown", {
    Title = "Teleport Mode",
    Values = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen"},
    Multi = false,
    Default = 1,
})

TeleportModeDropdown:SetValue("four")

TeleportModeDropdown:OnChanged(function(Value)
end)

local AutoTeleportToModeToggle = Tabs.Main:CreateToggle("MyToggle", {Title = "Auto Teleport To Mode", Default = false })

AutoTeleportToModeToggle:OnChanged(function()
    print("Toggle changed:", Options.MyToggle.Value)
end)

Options.MyToggle:SetValue(false)

local LureParagraph = Tabs.Main:CreateParagraph("Paragraph", {
    Title = "Lure:",
    Content = "0"
})

local config = {
    fpsCap = 9999,
    disableChat = false,
    enableBigButton = true,
    bigButtonScaleFactor = 2,
    shakeSpeed = 0.05,
    FreezeWhileFishing = true
}

-- FPS Cap
setfpscap(config.fpsCap)

-- Services
local players = game:GetService("Players")
local localplayer = players.LocalPlayer
local playergui = localplayer:WaitForChild("PlayerGui")
local vim = game:GetService("VirtualInputManager")
local run_service = game:GetService("RunService")
local replicated_storage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

-- Disable chat
if config.disableChat then
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
end

-- Utility functions
local utility = {blacklisted_attachments = {"bob", "bodyweld"}}

function utility.simulate_click(x, y, mb)
    vim:SendMouseButtonEvent(x, y, (mb - 1), true, game, 1)
    vim:SendMouseButtonEvent(x, y, (mb - 1), false, game, 1)
end

function utility.move_fix(bobber)
    for _, v in pairs(bobber:GetDescendants()) do
        if v:IsA("Attachment") and table.find(utility.blacklisted_attachments, v.Name) then
            v:Destroy()
        end
    end
end

-- Farm base
local farm = {
    reel_tick = nil,
    cast_tick = nil,

    find_rod_in_backpack = function()
        for _, tool in ipairs(localplayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("rod") then
                return tool
            end
        end
        return nil
    end
}

-- Auto Equip Rod Toggle
local Toggle_AutoRod = Tabs.Main:AddToggle("AutoRod", {Title = "Auto Equip Rod", Default = false})

Toggle_AutoRod:OnChanged(function()
    print("Auto Equip Rod:", Options.AutoRod.Value)

    task.spawn(function()
        while Options.AutoRod.Value do
            task.wait(0.2)

            local character = localplayer.Character
            if not character then continue end

            -- Check if already holding a rod
            local hasRodEquipped = false
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool.Name:lower():find("rod") then
                    hasRodEquipped = true
                    break
                end
            end

            -- If not holding a rod, equip it from backpack
            if not hasRodEquipped then
                local rod = farm.find_rod_in_backpack()
                if rod then
                    rod.Parent = character
                end
            end
        end
    end)
end)

-- Helper function to find the equipped rod
function find_rod()
    local character = localplayer.Character
    if not character then return nil end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("events") and tool.events:FindFirstChild("cast") then
            return tool
        end
    end

    return nil
end

-- Auto Cast Toggle
local Toggle_AutoCast = Tabs.Main:AddToggle("AutoCast", {Title = "Auto Cast", Default = false})

local autoCastRunning = false

Toggle_AutoCast:OnChanged(function()
    print("Auto Cast:", Options.AutoCast.Value)

    if Options.AutoCast.Value and not autoCastRunning then
        autoCastRunning = true
        task.spawn(function()
            while Options.AutoCast.Value do
                task.wait(1)

                local rod = find_rod()
                if rod and rod:FindFirstChild("events") and rod.events:FindFirstChild("cast") then
                    rod.events.cast:FireServer(100, 1)
                end
            end
            autoCastRunning = false
        end)
    end
end)

local Toggle_AutoShake = Tabs.Main:AddToggle("AutoShake", {Title = "Auto Shake", Default = false})

Toggle_AutoShake:OnChanged(function()
    print("Auto Shake:", Options.AutoShake.Value)

    task.spawn(function()
        while Options.AutoShake.Value do
            task.wait(config.shakeSpeed)

            local shake_ui = playergui:FindFirstChild("shakeui")
            if shake_ui then
                local safezone = shake_ui:FindFirstChild("safezone")
                local button = safezone and safezone:FindFirstChild("button")

                if button and button.Visible then
                    -- Scale the button
                    button.Size = config.enableBigButton
                        and UDim2.new(config.bigButtonScaleFactor, 0, config.bigButtonScaleFactor, 0)
                        or UDim2.new(1, 0, 1, 0)

                    utility.simulate_click(
                        button.AbsolutePosition.X + button.AbsoluteSize.X / 2,
                        button.AbsolutePosition.Y + button.AbsoluteSize.Y / 2,
                        1
                    )
                end
            end
        end
    end)
end)
                        

local Toggle_AutoReel = Tabs.Main:AddToggle("AutoReel", {Title = "Auto Reel", Default = false})

Toggle_AutoReel:OnChanged(function()
    print("Auto Reel:", Options.AutoReel.Value)

    task.spawn(function()
        while Options.AutoReel.Value do
            task.wait(0.5)

            local reel_ui = playergui:FindFirstChild("reel")
            if not reel_ui then continue end

            local reel_bar = reel_ui:FindFirstChild("bar")
            local reel_client = reel_bar and reel_bar:FindFirstChild("reel")
            if not reel_client then continue end

            if reel_client.Disabled then
                reel_client.Disabled = false
            end

            local update_colors = getsenv(reel_client).UpdateColors
            if update_colors then
                setupvalue(update_colors, 1, 100)
                replicated_storage.events.reelfinished:FireServer(getupvalue(update_colors, 1), true)
            end
        end
    end)
end)

Tabs.Main:AddSection("Farming Zone")
Tabs.Main:AddSection("Farming Event")
Tabs.Main:AddSection("Farming Nuke")
Tabs.Main:AddSection("Treasure Hunt")
Tabs.Main:AddSection("Sunken Treasure")
Tabs.Main:AddSection("Crystal")
Tabs.Main:AddSection("Bestiary Map")
Tabs.Main:AddSection("Rod")
Tabs.Main:AddSection("Summon")

Tabs.Auto:AddSection("Crab Cage")
Tabs.Auto:AddSection("Angler Fish")
Tabs.Auto:AddSection("Drill")
Tabs.Auto:AddSection("Bait")
Tabs.Auto:AddSection("Seller")
Tabs.Auto:AddSection("Latern Keeper")
Tabs.Auto:AddSection("Totem")
Tabs.Auto:AddSection("Trade")
Tabs.Auto:AddSection("Fillionaire")
Tabs.Auto:AddSection("Enchant Altar")
Tabs.Auto:AddSection("Farming Meteor")

Tabs.Invo:AddSection("Favorite")
Tabs.Invo:AddSection("Appraiser")
Tabs.Invo:AddSection("Chiseler")
Tabs.Invo:AddSection("Activate Tool")
Tabs.Invo:AddSection("Spin Crate")

Tabs.Shop:AddSection("Merlin")
Tabs.Shop:AddSection("Crates | Skin Merchant")
Tabs.Shop:AddSection("Shop Rod")
Tabs.Shop:AddSection("Shop Other")

Tabs.Quests:AddSection("Pierre")
Tabs.Quests:AddSection("Angler Quests")

Tabs.Tele:AddSection("Teleport Island")
Tabs.Tele:AddSection("Teleport NPCs")
Tabs.Tele:AddSection("Teleport Interactable")
Tabs.Tele:AddSection("Teleport Totem")
Tabs.Tele:AddSection("Teleport Zone Event")
Tabs.Tele:AddSection("Teleport Other")

Tabs.Misc:AddSection("ESP")
Tabs.Misc:AddSection("More FPS")
Tabs.Misc:AddSection("Character")
Tabs.Misc:AddSection("Misc Other")
Tabs.Misc:AddSection("Detection Staff")
Tabs.Misc:AddSection("Protect Identity")
Tabs.Misc:AddSection("Notification")

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes{}

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Library:Notify{
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
}

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
