--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local localplayer = game.Players.LocalPlayer
local services = {
    replicatedstorage = game:GetService("ReplicatedStorage"),
    players = game:GetService("Players"),
    runservice = game:GetService("RunService"),
}
local currentTarget = nil
local charactersfolder = game:GetService("Workspace").Characters

local circle = Drawing.new("Circle")
circle.Visible = false
circle.Transparency = 1
circle.Radius = 200
circle.NumSides = 164
circle.Color = Color3.fromRGB(255,255,255)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Window = Library:CreateWindow({
    Title = 'Sniper Duels by l10',
    Center = true, 
    AutoShow = true,
    Footer = "Verison 0.2 by l10"
})

local Tabs = {
    Main = Window:AddTab('Main', 'home'),
    Weapons = Window:AddTab('Weapons', 'sword'),
    UISettings = Window:AddTab('Settings', 'sliders-horizontal')
}

local SlientAimGroupbox = Tabs.Main:AddLeftGroupbox('Slient Aim')
local EspGroupBox = Tabs.Main:AddLeftGroupbox('ESP')
local GunModsGroupbox = Tabs.Weapons:AddLeftGroupbox('Gun Mods')
local KillauraGroupbox = Tabs.Main:AddRightGroupbox('Kill Aura')
local FieldOfViewBox = Tabs.Main:AddRightGroupbox('FOV')

local calculatespread = require(services.replicatedstorage:WaitForChild("Modules"):WaitForChild("Misc"):WaitForChild("CalculateSpread"))
local recoilcontroller = require(services.replicatedstorage:WaitForChild("Modules"):WaitForChild("Controllers"):WaitForChild("CameraController"))

local EnableNoSpreadToggle = GunModsGroupbox:AddToggle('EnableNoSpreadToggle1', {
    Text = 'Enable No Spread',
    Default = false, 
})

local EnableNoRecoilToggle = GunModsGroupbox:AddToggle('EnableNoRecoilToggle1', {
    Text = 'Enable No Recoil',
    Default = false, 
})

local targetnumber = 0
local oldSpread

if calculatespread and typeof(calculatespread) == "function" then
    local success, result = pcall(function()
        return hookfunction(calculatespread, function(...)
            local ok, shouldApply = pcall(function()
                return Toggles 
                    and Toggles.EnableNoSpreadToggle1 
                    and Toggles.EnableNoSpreadToggle1.Value == true
            end)
            
            if ok and shouldApply and type(targetnumber) == "number" then
                return targetnumber
            end

            return oldSpread(...)
        end)
    end)
    
    if success then
        oldSpread = result
    else
        warn("Failed to hook calculatespread:", result)
    end
end

if recoilcontroller and typeof(recoilcontroller) == "table" then
    for _, v in pairs(recoilcontroller) do
        if typeof(v) == "function" then
            local success, name = pcall(debug. info, v, "n")
            
            if success and name == "Recoil" then
                local oldRecoil
                local hookSuccess, hookResult = pcall(function()
                    return hookfunction(v, function(...)
                        local ok, shouldApply = pcall(function()
                            return Toggles 
                                and Toggles.EnableNoRecoilToggle1 
                                and Toggles.EnableNoRecoilToggle1.Value == true
                        end)
                        
                        if ok and shouldApply and type(targetnumber) == "number" then
                            return targetnumber
                        end

                        return oldRecoil(...)
                    end)
                end)
                
                if hookSuccess then
                    oldRecoil = hookResult
                else
                    warn("Failed to hook Recoil function:", hookResult)
                end
            end
        end
    end
end
--[[
local aimwalkspeedtable
local aimtimetable
local equiptimetable

local oldaimwalkspeed
local oldaimtime
local oldequiptime

for _, v in pairs(getgc(true)) do
    if type(v) == "table" then

        if rawget(v, "AimWalkspeedDecrease") then
            aimwalkspeedtable = v
            oldaimwalkspeed = v.AimWalkspeedDecrease
        end

        local aimIn = rawget(v, "AimIn")
        if type(aimIn) == "table" and rawget(aimIn, "Time") then
            aimtimetable = aimIn
            oldaimtime = aimIn.Time
        end

        if rawget(v, "EquipTime") then
            equiptimetable = v
            oldequiptime = v.EquipTime
        end
    end
end

local NoAimInTime = GunModsGroupbox:AddToggle('NoAimInTime1', {
    Text = 'Enable 0 Aim Time',
    Default = false, 
    Callback = function(state)
        if state == true then
            if aimtimetable then
                rawset(aimtimetable, "Time", 0)
            end
        else
            if aimtimetable then
                rawset(aimtimetable, "Time", oldaimtime)
            end
        end
    end
})

local NoAimInWalkspeed = GunModsGroupbox:AddToggle('NoAimInWalkspeed1', {
    Text = 'Disable AimInWalkspeed',
    Default = false, 
    Callback = function(state)
        if state == true then
            if aimwalkspeedtable then
                rawset(aimwalkspeedtable, "AimWalkspeedDecrease", 0)
            end
        else
            if aimwalkspeedtable then
                rawset(aimwalkspeedtable, "AimWalkspeedDecrease", oldaimwalkspeed)
            end
        end
    end
})

local NoEquipTime = GunModsGroupbox:AddToggle('NoEquipTime1', {
    Text = 'No Equip Time',
    Default = false, 
    Callback = function(state)
        if state == true then
            if equiptimetable then
                rawset(equiptimetable, "EquipTime", 0)
            end
        else
            if equiptimetable then
                rawset(equiptimetable, "EquipTime", oldequiptime)
            end
        end
    end
})]]

local slientaimtoggle = SlientAimGroupbox:AddToggle('slientaimtoggle1', {
    Text = 'Enable Slient Aim',
    Default = false, 
})

local aimpartslientaim = SlientAimGroupbox:AddDropdown("aimpartslientaim1", {
    Text = "Aim Part",
    Default = "Head",
    Values = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
})


local showfovtoggle = SlientAimGroupbox:AddToggle('showfovtoggle1', {
    Text = 'Enable Show FOV',
    Default = false, 

    Callback = function(Value)
        circle.Visible = Value
    end
})

local fovsizeslider = SlientAimGroupbox:AddSlider('fovsizeslider1', {
    Text = 'FOV Size Changer',
    Default = 200,
    Min = 5,
    Max = 1000,
    Rounding = 1,
    Compact = false, 

    Callback = function(Value)
        circle.Radius = Value
    end
})

local SlientAimWallCheck = SlientAimGroupbox:AddToggle('SlientAimWallCheck1', {
    Text = 'Wall Check',
    Default = false, 
})


local SlientAimTeamCheck = SlientAimGroupbox:AddToggle('SlientAimTeamCheck1', {
    Text = 'Team Switch',
    Default = false, 
})

services.runservice.RenderStepped:Connect(function()
    if workspace.CurrentCamera then
        circle.Position = workspace.CurrentCamera.ViewportSize / 2
    end
end)

local function isVisible(targetPart, origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {localplayer.Character}

    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude

    local result = workspace:Raycast(origin, direction, raycastParams)

    if result then
        if result.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        else
            return false
        end
    else
        return false
    end
end

local function teamcheckplr(player)
    local char = player.Character
    if not char then return false end

    local mychar = localplayer.Character
    if not mychar then return false end

    local localteam = nil
    local playerteam = nil

    for index, folder in pairs(charactersfolder:GetChildren()) do
        if folder:IsA("Folder") then
            if folder:FindFirstChild(mychar.Name, true) then
                local chara = folder:FindFirstChild(mychar.Name, true)

                if chara then
                    localteam = chara.Parent.Name
                end
            end
            if folder:FindFirstChild(char.Name, true) then
                local chara = folder:FindFirstChild(char.Name, true)

                if chara then
                    playerteam = chara.Parent.Name
                end
            end
        end
    end

    if localteam == playerteam then
        return true
    else
        return false
    end
end

local function returnTeamFolder()
    local myChar = localplayer.Character
    if not myChar then
        return nil
    end

    for _, teamFolder in pairs(charactersfolder:GetChildren()) do
        if teamFolder:IsA("Folder") then
            if teamFolder:FindFirstChild(myChar.Name, true) then
                return teamFolder
            end
        end
    end

    return nil
end

local function isPlayerInMyTeam(player)
    local teamFolder = returnTeamFolder()
    if not teamFolder then
        return false
    end

    if not player.Character then
        return false
    end

    for _, child in pairs(teamFolder:GetDescendants()) do
        if child:IsA("Model") and child.Name == player.Character.Name then
            return true
        end
    end
    
    return false
end

local function closestplayer()
    local closest = nil
    local closestdistance = math.huge
    local origin = workspace.CurrentCamera.CFrame.Position
    local center = circle.Position

    for _, player in pairs(services.players:GetPlayers()) do
        if player and player.Character then
            local char = player.Character
            if char:FindFirstChild("HumanoidRootPart") then
                local part1 = char:FindFirstChild(aimpartslientaim.Value)
                local screenpos, onscreen = workspace.CurrentCamera:WorldToViewportPoint(part1.Position)

                if onscreen then
                    if SlientAimWallCheck and SlientAimWallCheck.Value then
                        if not isVisible(part1, origin) then
                            continue
                        end
                    end

                    local distance = (Vector2.new(screenpos.X,screenpos.Y) - center).Magnitude

                    if distance <= circle.Radius and distance < closestdistance then
                        closest = player
                        closestdistance = distance
                    end
                end
            end
        end
    end

    return closest
end

services.runservice.RenderStepped:Connect(function()
    currentTarget = closestplayer()
end)

local multray = require(services.replicatedstorage.Modules.Misc.MultiRaycast)

local old
old = hookfunction(multray, function(origin, direction, params, p4, p5)
    if typeof(old) ~= "function" or typeof(origin) ~= "Vector3" or typeof(direction) ~= "Vector3" then
        return old and old(origin, direction, params, p4, p5)
    end

    if not Toggles or not Toggles.slientaimtoggle1 or not Toggles.slientaimtoggle1.Value then
        return old(origin, direction, params, p4, p5)
    end

    if not currentTarget or not currentTarget.Character or not currentTarget.Character. Parent then
        return old(origin, direction, params, p4, p5)
    end

    if typeof(teamcheckplr) == "function" then
        if SlientAimTeamCheck and SlientAimTeamCheck.Value then
            local ok, sameTeam = pcall(teamcheckplr, currentTarget)
            if ok and sameTeam then
                return old(origin, direction, params, p4, p5)
            end
        end
    end

    local head = currentTarget.Character:FindFirstChild("Head")
    if not head or not head.Position or typeof(head.Position) ~= "Vector3" then
        return old(origin, direction, params, p4, p5)
    end

    local newDirection = head.Position - origin
    if newDirection. Magnitude > 0 then
        direction = newDirection.Unit * direction.Magnitude
    end

    return old(origin, direction, params, p4, p5)

end)

local boxesps = {}
local lineEsps = {}

local function createEsp(player)
    local box = Drawing.new("Square")
    box.Filled = false
    box.Visible = false
    box.Transparency = 1
    box.Thickness = 1.5
    box.Color = Color3.fromRGB(255,255,255)

    local line = Drawing.new("Line")
    line.Visible = false
    line.Transparency = 1
    line.Thickness = 1
    line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)

    boxesps[player] = {Box = box}
    lineEsps[player] = {Line = line}
end

local function removeEsp(player)
    local boxData = boxesps[player]
    if boxData and boxData.Box then
        boxData.Box:Remove()
    end
    boxesps[player] = nil

    local lineData = lineEsps[player]
    if lineData and lineData.Line then
        lineData.Line:Remove()
    end
    lineEsps[player] = nil
end


services.players.PlayerAdded:Connect(createEsp)
services.players.PlayerRemoving:Connect(removeEsp)

for i, v in pairs(services.players:GetPlayers()) do  
    if v == localplayer then
        continue
    end

    createEsp(v)
end

local traceresptoggle = EspGroupBox:AddToggle('traceresptoggle1', {
    Text = 'Tracer ESP',
    Default = false,
    Callback = function(Value)
        for _, data in pairs(lineEsps) do
            if data.Line then
                data.Line.Visible = Value
            end
        end
    end
})

local tracertransparencyslider = EspGroupBox:AddSlider('tracertransparency', {
    Text = 'Tracer Transparency',
    Default = 1,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)

    end
})

local boxesptoggle = EspGroupBox:AddToggle('boxesptoggle1', {
    Text = 'Box ESP',
    Default = false,
    Callback = function(Value)
        for _, data in pairs(boxesps) do
            if data.Box then
                data.Box.Visible = Value
            end
        end
    end
})

local boxtransparencyslider = EspGroupBox:AddSlider('boxtransparency', {
    Text = 'Box Transparency',
    Default = 1,
    Min = 0,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)

    end
})

EspGroupBox:AddDivider()

EspGroupBox:AddLabel('Team Color'):AddColorPicker('TeamColorEspPicker1', {
    Default = Color3.fromRGB(0, 204, 17), 
    Title = 'Team Color',
})

EspGroupBox:AddLabel('Enemy Color'):AddColorPicker('EnemyColorEspPicker1', {
    Default = Color3.fromRGB(153, 0, 0), 
    Title = 'Enemy Color',
})

services.runservice.RenderStepped:Connect(function()
    if not (Toggles.boxesptoggle1.Value or Toggles.traceresptoggle1.Value) then
        return
    end

    for _, player in ipairs(services.players:GetPlayers()) do
        if player == localplayer then continue end

        local esp = boxesps[player]
        local tracer = lineEsps[player]

        if not esp or not esp.Box or not tracer or not tracer.Line then
            continue
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if not hrp then
            esp.Box.Visible = false
            tracer.Line.Visible = false
            continue
        end

        local pos, onscreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
        if not onscreen then
            esp.Box.Visible = false
            tracer.Line.Visible = false
            continue
        end

        local dist = (workspace.CurrentCamera.CFrame.Position - hrp.Position).Magnitude
        local scale = math.clamp(1000 / dist, 1, 10)
        local width, height = 4 * scale, 6 * scale

        local targetColor = teamcheckplr(player)
            and Options.TeamColorEspPicker1.Value
            or Options.EnemyColorEspPicker1.Value

        if Toggles.boxesptoggle1.Value then
            esp.Box.Visible = true
            esp.Box.Size = Vector2.new(width, height)
            esp.Box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
            esp.Box.Color = targetColor
        else
            esp.Box.Visible = false
        end

        if Toggles.traceresptoggle1.Value then
            tracer.Line.Visible = true
            tracer.Line.From = Vector2.new(
                workspace.CurrentCamera.ViewportSize.X / 2,
                workspace.CurrentCamera.ViewportSize.Y
            )
            tracer.Line.To = Vector2.new(pos.X, pos.Y)
            tracer.Line.Color = targetColor
        else
            tracer.Line.Visible = false
        end
    end
end)

local KnifeAuraToggle = KillauraGroupbox:AddToggle('KnifeAuraToggle1', {
    Text = 'Knife Aura',
    Default = false,
    Callback = function(Value)

    end
})

local KnifeAuraRange = KillauraGroupbox:AddSlider('KnifeAuraRange1', {
    Text = 'Range',
    Default = 20,
    Min = 1,
    Max = 50,
    Rounding = 2,
    Callback = function(Value)

    end
})

local KnifeAuraSpeed = KillauraGroupbox:AddSlider('KnifeAuraSpeed1', {
    Text = 'Speed',
    Default = 0.05,
    Min = 0,
    Max = 2,
    Rounding = 4,
    Callback = function(Value)

    end
})

local KnifeAuraTeamCheck = KillauraGroupbox:AddToggle('KnifeAuraTeamCheck1', {
    Text = 'Team Check',
    Default = false,
    Callback = function(Value)

    end
})

local KnifeAuraWallCheck = KillauraGroupbox:AddToggle('KnifeAuraWallCheck1', {
    Text = 'Wall Check',
    Default = false,
    Callback = function(Value)

    end
})

task.spawn(function()
    while true do
        task.wait()

        if KnifeAuraToggle.Value then 
            local myChar = localplayer.Character
            if not myChar then continue end

            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then continue end

            for _, plr in ipairs(services.players:GetPlayers()) do
                if plr == localplayer then continue end
                if KnifeAuraTeamCheck.Value then
                    if teamcheckplr(plr) then
                        continue 
                    end
                end

                local char = plr.Character
                if not char then continue end

                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChild("Humanoid")
                
                if not hrp or not humanoid then continue end

                if KnifeAuraWallCheck.Value then
                    if not isVisible(hrp, workspace.CurrentCamera.CFrame.Position) then
                        continue
                    end
                end

                if (myRoot.Position - hrp.Position).Magnitude <= KnifeAuraRange.Value then
                    services.replicatedstorage:FindFirstChild("Remotes"):FindFirstChild("Weapons"):FindFirstChild("Melee"):FindFirstChild("Swing"):FireServer(
                        workspace:GetServerTimeNow(),
                        humanoid,
                        buffer.create(1)
                    )
                    task.wait(0.05)
                end
            end
        end
    end
end)

local FOVOverrideToggle = FieldOfViewBox:AddToggle('FOVOverrideToggle', {
    Text = 'Enable FOV Override',
    Default = false,
    Callback = function(Value)

    end
})

local FovSlider = FieldOfViewBox:AddSlider('FovSlider1', {
    Text = 'FOV',
    Default = 80,
    Min = 10,
    Max = 120,
    Rounding = 3,
    Callback = function(Value)

    end
})

FieldOfViewBox:AddButton({
    Text = "Reset FOV",
    Func = function()
        if FovSlider then
            FovSlider:SetValue(80)
        end
    end
})

game.RunService.RenderStepped:Connect(function()
    if FOVOverrideToggle and FOVOverrideToggle.Value then
        workspace.CurrentCamera.FieldOfView = FovSlider.Value
    end
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("l10scripthub")
SaveManager:SetFolder("l10scripthub/sniperduels")

SaveManager:BuildConfigSection(Tabs["UISettings"])

ThemeManager:ApplyToTab(Tabs["UISettings"])

SaveManager:LoadAutoloadConfig()
