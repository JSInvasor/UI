--[[
    ██████╗  █████╗ ██╗███╗   ███╗██╗     ███████╗███████╗███████╗
    ██╔══██╗██╔══██╗██║████╗ ████║██║     ██╔════╝██╔════╝██╔════╝
    ██████╔╝███████║██║██╔████╔██║██║     █████╗  ███████╗███████╗
    ██╔══██╗██╔══██║██║██║╚██╔╝██║██║     ██╔══╝  ╚════██║╚════██║
    ██████╔╝██║  ██║██║██║ ╚═╝ ██║███████╗███████╗███████║███████║
    ╚═════╝ ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝
    
    Baimless Style UI Library for Roblox
    Version: 1.0.0
    
    Features:
    - Modern glassmorphism design
    - Smooth gradient animations
    - CS:GO Baimless inspired aesthetics
    - Draggable windows
    - Tabs, toggles, sliders, dropdowns, buttons, keybinds
--]]

local BaimlessUI = {}
BaimlessUI.__index = BaimlessUI

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

-- Theme Configuration
local Theme = {
    -- Main Colors
    Background = Color3.fromRGB(15, 15, 20),
    BackgroundSecondary = Color3.fromRGB(20, 20, 28),
    BackgroundTertiary = Color3.fromRGB(25, 25, 35),
    
    -- Accent Colors (Magenta/Purple Gradient)
    AccentPrimary = Color3.fromRGB(180, 50, 180),
    AccentSecondary = Color3.fromRGB(130, 40, 200),
    AccentGlow = Color3.fromRGB(200, 80, 200),
    
    -- Text Colors
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 180),
    TextMuted = Color3.fromRGB(120, 120, 120),
    
    -- UI Colors
    Border = Color3.fromRGB(50, 50, 60),
    SliderBackground = Color3.fromRGB(40, 40, 50),
    ToggleOff = Color3.fromRGB(60, 60, 70),
    
    -- Fonts
    FontBold = Enum.Font.GothamBold,
    FontMedium = Enum.Font.GothamMedium,
    FontRegular = Enum.Font.Gotham,
    
    -- Sizing
    CornerRadius = UDim.new(0, 8),
    CornerRadiusSmall = UDim.new(0, 4),
    CornerRadiusLarge = UDim.new(0, 12),
}

-- Utility Functions
local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quart, easingDirection or Enum.EasingDirection.Out),
        properties
    )
    return tween
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or Theme.CornerRadius
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.5
    stroke.Parent = parent
    return stroke
end

local function AddGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors or {
        ColorSequenceKeypoint.new(0, Theme.AccentPrimary),
        ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
    })
    gradient.Rotation = rotation or 45
    gradient.Parent = parent
    return gradient
end

local function CreateDropShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = parent
    return shadow
end

-- Main Window Creation
function BaimlessUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Baimless"
    local windowSize = config.Size or UDim2.new(0, 580, 0, 420)
    local logoText = config.Logo or "AKI"
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BaimlessUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    pcall(function()
        ScreenGui.Parent = CoreGui
    end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    end
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = windowSize
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    AddCorner(MainFrame, Theme.CornerRadiusLarge)
    AddStroke(MainFrame, Theme.Border, 1, 0.7)
    CreateDropShadow(MainFrame)
    
    -- Background Gradient Overlay
    local BGOverlay = Instance.new("Frame")
    BGOverlay.Name = "BGOverlay"
    BGOverlay.BackgroundColor3 = Theme.AccentPrimary
    BGOverlay.BackgroundTransparency = 0.95
    BGOverlay.Size = UDim2.new(1, 0, 1, 0)
    BGOverlay.ZIndex = 0
    BGOverlay.Parent = MainFrame
    AddCorner(BGOverlay, Theme.CornerRadiusLarge)
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Theme.BackgroundSecondary
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.Parent = MainFrame
    
    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = Theme.CornerRadiusLarge
    topBarCorner.Parent = TopBar
    
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Name = "CornerFix"
    TopBarFix.BackgroundColor3 = Theme.BackgroundSecondary
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Position = UDim2.new(0, 0, 1, -12)
    TopBarFix.Size = UDim2.new(1, 0, 0, 12)
    TopBarFix.Parent = TopBar
    
    -- Logo Container
    local LogoContainer = Instance.new("Frame")
    LogoContainer.Name = "LogoContainer"
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Position = UDim2.new(0, 15, 0, 0)
    LogoContainer.Size = UDim2.new(0, 80, 1, 0)
    LogoContainer.Parent = TopBar
    
    -- Logo Text with Gradient
    local LogoText = Instance.new("TextLabel")
    LogoText.Name = "Logo"
    LogoText.BackgroundTransparency = 1
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.Font = Theme.FontBold
    LogoText.Text = logoText
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.TextSize = 28
    LogoText.Parent = LogoContainer
    
    -- Animated Logo Gradient
    local logoGradient = Instance.new("UIGradient")
    logoGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Theme.AccentPrimary),
        ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
    })
    logoGradient.Rotation = 0
    logoGradient.Parent = LogoText
    
    spawn(function()
        while ScreenGui.Parent do
            for i = 0, 360, 2 do
                logoGradient.Rotation = i
                wait(0.03)
            end
        end
    end)
    
    -- Stats Display (FPS / Ping)
    local StatsContainer = Instance.new("Frame")
    StatsContainer.Name = "Stats"
    StatsContainer.BackgroundColor3 = Theme.BackgroundTertiary
    StatsContainer.Position = UDim2.new(0, 110, 0.5, 0)
    StatsContainer.AnchorPoint = Vector2.new(0, 0.5)
    StatsContainer.Size = UDim2.new(0, 80, 0, 35)
    StatsContainer.Parent = TopBar
    AddCorner(StatsContainer, Theme.CornerRadiusSmall)
    
    local FPSLabel = Instance.new("TextLabel")
    FPSLabel.Name = "FPS"
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.Position = UDim2.new(0, 8, 0, 3)
    FPSLabel.Size = UDim2.new(1, -16, 0, 14)
    FPSLabel.Font = Theme.FontMedium
    FPSLabel.Text = "FPS : --"
    FPSLabel.TextColor3 = Theme.TextSecondary
    FPSLabel.TextSize = 11
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
    FPSLabel.Parent = StatsContainer
    
    local PingLabel = Instance.new("TextLabel")
    PingLabel.Name = "Ping"
    PingLabel.BackgroundTransparency = 1
    PingLabel.Position = UDim2.new(0, 8, 0, 17)
    PingLabel.Size = UDim2.new(1, -16, 0, 14)
    PingLabel.Font = Theme.FontMedium
    PingLabel.Text = "Ping : --"
    PingLabel.TextColor3 = Theme.TextSecondary
    PingLabel.TextSize = 11
    PingLabel.TextXAlignment = Enum.TextXAlignment.Left
    PingLabel.Parent = StatsContainer
    
    -- Update FPS/Ping
    spawn(function()
        local lastTime = tick()
        local frameCount = 0
        while ScreenGui.Parent do
            frameCount = frameCount + 1
            local currentTime = tick()
            if currentTime - lastTime >= 1 then
                local fps = math.floor(frameCount / (currentTime - lastTime))
                FPSLabel.Text = "FPS : " .. fps
                frameCount = 0
                lastTime = currentTime
            end
            
            local ping = Player:GetNetworkPing() * 1000
            PingLabel.Text = "Ping : " .. math.floor(ping)
            
            RunService.RenderStepped:Wait()
        end
    end)
    
    -- User Info
    local UserContainer = Instance.new("Frame")
    UserContainer.Name = "UserInfo"
    UserContainer.BackgroundColor3 = Theme.BackgroundTertiary
    UserContainer.Position = UDim2.new(0, 200, 0.5, 0)
    UserContainer.AnchorPoint = Vector2.new(0, 0.5)
    UserContainer.Size = UDim2.new(0, 150, 0, 35)
    UserContainer.Parent = TopBar
    AddCorner(UserContainer, Theme.CornerRadiusSmall)
    
    -- User Avatar
    local Avatar = Instance.new("ImageLabel")
    Avatar.Name = "Avatar"
    Avatar.BackgroundColor3 = Theme.BackgroundSecondary
    Avatar.Position = UDim2.new(0, 5, 0.5, 0)
    Avatar.AnchorPoint = Vector2.new(0, 0.5)
    Avatar.Size = UDim2.new(0, 25, 0, 25)
    Avatar.Parent = UserContainer
    AddCorner(Avatar, UDim.new(0, 4))
    
    pcall(function()
        Avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
    end)
    
    local UsernameLabel = Instance.new("TextLabel")
    UsernameLabel.Name = "Username"
    UsernameLabel.BackgroundTransparency = 1
    UsernameLabel.Position = UDim2.new(0, 35, 0, 3)
    UsernameLabel.Size = UDim2.new(1, -40, 0, 14)
    UsernameLabel.Font = Theme.FontMedium
    UsernameLabel.Text = Player.Name
    UsernameLabel.TextColor3 = Theme.TextPrimary
    UsernameLabel.TextSize = 12
    UsernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    UsernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    UsernameLabel.Parent = UserContainer
    
    local ExpiryLabel = Instance.new("TextLabel")
    ExpiryLabel.Name = "Expiry"
    ExpiryLabel.BackgroundTransparency = 1
    ExpiryLabel.Position = UDim2.new(0, 35, 0, 17)
    ExpiryLabel.Size = UDim2.new(1, -40, 0, 14)
    ExpiryLabel.Font = Theme.FontRegular
    ExpiryLabel.Text = "Expiry : Lifetime"
    ExpiryLabel.TextColor3 = Theme.AccentPrimary
    ExpiryLabel.TextSize = 10
    ExpiryLabel.TextXAlignment = Enum.TextXAlignment.Left
    ExpiryLabel.Parent = UserContainer
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.BackgroundTransparency = 0.8
    CloseButton.Position = UDim2.new(1, -40, 0.5, 0)
    CloseButton.AnchorPoint = Vector2.new(0, 0.5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Theme.FontBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.TextSize = 18
    CloseButton.Parent = TopBar
    AddCorner(CloseButton, Theme.CornerRadiusSmall)
    
    CloseButton.MouseEnter:Connect(function()
        CreateTween(CloseButton, {BackgroundTransparency = 0.5}, 0.2):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        CreateTween(CloseButton, {BackgroundTransparency = 0.8}, 0.2):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
    MinimizeButton.BackgroundTransparency = 0.8
    MinimizeButton.Position = UDim2.new(1, -70, 0.5, 0)
    MinimizeButton.AnchorPoint = Vector2.new(0, 0.5)
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Font = Theme.FontBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Color3.fromRGB(200, 200, 50)
    MinimizeButton.TextSize = 18
    MinimizeButton.Parent = TopBar
    AddCorner(MinimizeButton, Theme.CornerRadiusSmall)
    
    local minimized = false
    local originalSize = windowSize
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(MainFrame, {Size = UDim2.new(0, originalSize.X.Offset, 0, 50)}, 0.3):Play()
        else
            CreateTween(MainFrame, {Size = originalSize}, 0.3):Play()
        end
    end)
    
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.BackgroundColor3 = Theme.BackgroundSecondary
    Sidebar.BackgroundTransparency = 0.3
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.Size = UDim2.new(0, 130, 1, -50)
    Sidebar.Parent = MainFrame
    
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = Theme.CornerRadiusLarge
    sidebarCorner.Parent = Sidebar
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Name = "CornerFix"
    SidebarFix.BackgroundColor3 = Theme.BackgroundSecondary
    SidebarFix.BackgroundTransparency = 0.3
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Position = UDim2.new(1, -12, 0, 0)
    SidebarFix.Size = UDim2.new(0, 12, 1, 0)
    SidebarFix.Parent = Sidebar
    
    local SidebarFixTop = Instance.new("Frame")
    SidebarFixTop.Name = "CornerFixTop"
    SidebarFixTop.BackgroundColor3 = Theme.BackgroundSecondary
    SidebarFixTop.BackgroundTransparency = 0.3
    SidebarFixTop.BorderSizePixel = 0
    SidebarFixTop.Position = UDim2.new(0, 0, 0, 0)
    SidebarFixTop.Size = UDim2.new(0, 12, 0, 12)
    SidebarFixTop.Parent = Sidebar
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 0, 0, 15)
    TabContainer.Size = UDim2.new(1, 0, 1, -15)
    TabContainer.Parent = Sidebar
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.Parent = TabContainer
    
    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 140, 0, 60)
    ContentArea.Size = UDim2.new(1, -150, 1, -70)
    ContentArea.Parent = MainFrame
    
    -- Dragging
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TopBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Opening Animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    CreateTween(MainFrame, {Size = windowSize}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out):Play()
    
    -- Window Object
    local Window = {}
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.TabContainer = TabContainer
    Window.ContentArea = ContentArea
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    -- Tab Icons
    local Icons = {
        catching = "rbxassetid://7733960981",
        physics = "rbxassetid://7734053495",
        blocking = "rbxassetid://7743878857",
        tackling = "rbxassetid://7734010953",
        coverage = "rbxassetid://7734017432",
        visuals = "rbxassetid://7734021747",
        settings = "rbxassetid://7734027623",
        player = "rbxassetid://7733756006",
        misc = "rbxassetid://7733964370",
        default = "rbxassetid://7733960981"
    }
    
    -- Create Tab Function
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or Icons[string.lower(tabName)] or Icons.default
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.BackgroundColor3 = Theme.AccentPrimary
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Font = Theme.FontMedium
        TabButton.Text = ""
        TabButton.Parent = TabContainer
        AddCorner(TabButton, Theme.CornerRadiusSmall)
        
        -- Selection Indicator
        local SelectionIndicator = Instance.new("Frame")
        SelectionIndicator.Name = "Indicator"
        SelectionIndicator.BackgroundColor3 = Theme.AccentPrimary
        SelectionIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        SelectionIndicator.AnchorPoint = Vector2.new(0, 0.5)
        SelectionIndicator.Size = UDim2.new(0, 3, 0.6, 0)
        SelectionIndicator.Visible = false
        SelectionIndicator.Parent = TabButton
        AddCorner(SelectionIndicator, UDim.new(0, 2))
        AddGradient(SelectionIndicator, {
            ColorSequenceKeypoint.new(0, Theme.AccentPrimary),
            ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
        }, 90)
        
        -- Tab Icon
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "Icon"
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0.5, 0)
        TabIcon.AnchorPoint = Vector2.new(0, 0.5)
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Image = tabIcon
        TabIcon.ImageColor3 = Theme.TextSecondary
        TabIcon.Parent = TabButton
        
        -- Tab Label
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.BackgroundTransparency = 1
        TabLabel.Position = UDim2.new(0, 35, 0, 0)
        TabLabel.Size = UDim2.new(1, -40, 1, 0)
        TabLabel.Font = Theme.FontMedium
        TabLabel.Text = tabName
        TabLabel.TextColor3 = Theme.TextSecondary
        TabLabel.TextSize = 13
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content Page
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = tabName .. "Page"
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollBarImageColor3 = Theme.AccentPrimary
        TabPage.Visible = false
        TabPage.Parent = ContentArea
        
        local PageLayout = Instance.new("UIGridLayout")
        PageLayout.CellPadding = UDim2.new(0, 10, 0, 10)
        PageLayout.CellSize = UDim2.new(0.48, 0, 0, 200)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage
        
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab Selection Logic
        local function SelectTab()
            for _, tab in pairs(Window.Tabs) do
                tab.Button.BackgroundTransparency = 1
                tab.Indicator.Visible = false
                tab.Icon.ImageColor3 = Theme.TextSecondary
                tab.Label.TextColor3 = Theme.TextSecondary
                tab.Page.Visible = false
            end
            
            CreateTween(TabButton, {BackgroundTransparency = 0.85}, 0.2):Play()
            SelectionIndicator.Visible = true
            TabIcon.ImageColor3 = Theme.AccentPrimary
            TabLabel.TextColor3 = Theme.TextPrimary
            TabPage.Visible = true
            Window.ActiveTab = tabName
        end
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= tabName then
                CreateTween(TabButton, {BackgroundTransparency = 0.9}, 0.2):Play()
                CreateTween(TabIcon, {ImageColor3 = Theme.TextPrimary}, 0.2):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= tabName then
                CreateTween(TabButton, {BackgroundTransparency = 1}, 0.2):Play()
                CreateTween(TabIcon, {ImageColor3 = Theme.TextSecondary}, 0.2):Play()
            end
        end)
        
        TabButton.MouseButton1Click:Connect(SelectTab)
        
        local Tab = {
            Button = TabButton,
            Indicator = SelectionIndicator,
            Icon = TabIcon,
            Label = TabLabel,
            Page = TabPage
        }
        Window.Tabs[tabName] = Tab
        
        if not Window.ActiveTab then
            SelectTab()
        end
        
        -- Section Creator
        function Tab:CreateSection(config)
            config = config or {}
            local sectionName = config.Name or "Section"
            local sectionDescription = config.Description or ""
            
            local Section = Instance.new("Frame")
            Section.Name = sectionName
            Section.BackgroundColor3 = Theme.BackgroundSecondary
            Section.BackgroundTransparency = 0.3
            Section.Size = UDim2.new(1, 0, 0, 50)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.Parent = TabPage
            AddCorner(Section, Theme.CornerRadius)
            AddStroke(Section, Theme.Border, 1, 0.8)
            
            local Header = Instance.new("TextLabel")
            Header.Name = "Header"
            Header.BackgroundTransparency = 1
            Header.Position = UDim2.new(0, 15, 0, 10)
            Header.Size = UDim2.new(1, -30, 0, 20)
            Header.Font = Theme.FontBold
            Header.Text = sectionName
            Header.TextColor3 = Theme.AccentPrimary
            Header.TextSize = 14
            Header.TextXAlignment = Enum.TextXAlignment.Left
            Header.Parent = Section
            
            if sectionDescription ~= "" then
                local Desc = Instance.new("TextLabel")
                Desc.Name = "Description"
                Desc.BackgroundTransparency = 1
                Desc.Position = UDim2.new(0, 15, 0, 28)
                Desc.Size = UDim2.new(1, -30, 0, 14)
                Desc.Font = Theme.FontRegular
                Desc.Text = sectionDescription
                Desc.TextColor3 = Theme.TextMuted
                Desc.TextSize = 11
                Desc.TextXAlignment = Enum.TextXAlignment.Left
                Desc.Parent = Section
            end
            
            local ElementsContainer = Instance.new("Frame")
            ElementsContainer.Name = "Elements"
            ElementsContainer.BackgroundTransparency = 1
            ElementsContainer.Position = UDim2.new(0, 15, 0, sectionDescription ~= "" and 50 or 35)
            ElementsContainer.Size = UDim2.new(1, -30, 0, 0)
            ElementsContainer.AutomaticSize = Enum.AutomaticSize.Y
            ElementsContainer.Parent = Section
            
            local ElementsLayout = Instance.new("UIListLayout")
            ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ElementsLayout.Padding = UDim.new(0, 8)
            ElementsLayout.Parent = ElementsContainer
            
            local BottomPad = Instance.new("Frame")
            BottomPad.Name = "BottomPad"
            BottomPad.BackgroundTransparency = 1
            BottomPad.Size = UDim2.new(1, 0, 0, 10)
            BottomPad.LayoutOrder = 9999
            BottomPad.Parent = ElementsContainer
            
            local SectionObj = {}
            
            -- Toggle Element
            function SectionObj:CreateToggle(config)
                config = config or {}
                local toggleName = config.Name or "Toggle"
                local default = config.Default or false
                local callback = config.Callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = toggleName
                ToggleFrame.BackgroundTransparency = 1
                ToggleFrame.Size = UDim2.new(1, 0, 0, 25)
                ToggleFrame.Parent = ElementsContainer
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Font = Theme.FontMedium
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = Theme.TextPrimary
                ToggleLabel.TextSize = 12
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleButton = Instance.new("Frame")
                ToggleButton.Name = "Button"
                ToggleButton.BackgroundColor3 = default and Theme.AccentPrimary or Theme.ToggleOff
                ToggleButton.Position = UDim2.new(1, -40, 0.5, 0)
                ToggleButton.AnchorPoint = Vector2.new(0, 0.5)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Parent = ToggleFrame
                AddCorner(ToggleButton, UDim.new(0, 10))
                
                if default then
                    AddGradient(ToggleButton, {
                        ColorSequenceKeypoint.new(0, Theme.AccentPrimary),
                        ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
                    }, 0)
                end
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "Circle"
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
                ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
                ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
                ToggleCircle.Parent = ToggleButton
                AddCorner(ToggleCircle, UDim.new(1, 0))
                
                local Checkmark = Instance.new("TextLabel")
                Checkmark.Name = "Check"
                Checkmark.BackgroundTransparency = 1
                Checkmark.Size = UDim2.new(1, 0, 1, 0)
                Checkmark.Font = Theme.FontBold
                Checkmark.Text = default and "✓" or ""
                Checkmark.TextColor3 = Theme.AccentPrimary
                Checkmark.TextSize = 10
                Checkmark.Parent = ToggleCircle
                
                local toggled = default
                
                local ClickButton = Instance.new("TextButton")
                ClickButton.Name = "ClickArea"
                ClickButton.BackgroundTransparency = 1
                ClickButton.Size = UDim2.new(1, 0, 1, 0)
                ClickButton.Text = ""
                ClickButton.Parent = ToggleFrame
                
                ClickButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    if toggled then
                        CreateTween(ToggleCircle, {Position = UDim2.new(1, -18, 0.5, 0)}, 0.2):Play()
                        CreateTween(ToggleButton, {BackgroundColor3 = Theme.AccentPrimary}, 0.2):Play()
                        Checkmark.Text = "✓"
                        
                        local existingGradient = ToggleButton:FindFirstChildOfClass("UIGradient")
                        if not existingGradient then
                            AddGradient(ToggleButton, {
                                ColorSequenceKeypoint.new(0, Theme.AccentPrimary),
                                ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
                            }, 0)
                        end
                    else
                        CreateTween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, 0)}, 0.2):Play()
                        CreateTween(ToggleButton, {BackgroundColor3 = Theme.ToggleOff}, 0.2):Play()
                        Checkmark.Text = ""
                        
                        local existingGradient = ToggleButton:FindFirstChildOfClass("UIGradient")
                        if existingGradient then
                            existingGradient:Destroy()
                        end
                    end
                    
                    callback(toggled)
                end)
                
                local ToggleObj = {}
                function ToggleObj:Set(value)
                    if toggled ~= value then
                        ClickButton.MouseButton1Click:Fire()
                    end
                end
                
                return ToggleObj
            end
            
            -- Slider Element
            function SectionObj:CreateSlider(config)
                config = config or {}
                local sliderName = config.Name or "Slider"
                local min = config.Min or 0
                local max = config.Max or 100
                local default = config.Default or min
                local increment = config.Increment or 1
                local callback = config.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = sliderName
                SliderFrame.BackgroundTransparency = 1
                SliderFrame.Size = UDim2.new(1, 0, 0, 40)
                SliderFrame.Parent = ElementsContainer
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Size = UDim2.new(1, -50, 0, 18)
                SliderLabel.Font = Theme.FontMedium
                SliderLabel.Text = sliderName
                SliderLabel.TextColor3 = Theme.TextPrimary
                SliderLabel.TextSize = 12
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "Value"
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Position = UDim2.new(1, -45, 0, 0)
                ValueLabel.Size = UDim2.new(0, 45, 0, 18)
                ValueLabel.Font = Theme.FontMedium
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Theme.TextSecondary
                ValueLabel.TextSize = 12
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame
                
                local SliderBG = Instance.new("Frame")
                SliderBG.Name = "Background"
                SliderBG.BackgroundColor3 = Theme.SliderBackground
                SliderBG.Position = UDim2.new(0, 0, 0, 22)
                SliderBG.Size = UDim2.new(1, 0, 0, 6)
                SliderBG.Parent = SliderFrame
                AddCorner(SliderBG, UDim.new(1, 0))
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.BackgroundColor3 = Theme.AccentPrimary
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.Parent = SliderBG
                AddCorner(SliderFill, UDim.new(1, 0))
                AddGradient(SliderFill, {
                    ColorSequenceKeypoint.new(0, Theme.AccentPrimary),
                    ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
                }, 0)
                
                local SliderDot = Instance.new("Frame")
                SliderDot.Name = "Dot"
                SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderDot.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
                SliderDot.Size = UDim2.new(0, 14, 0, 14)
                SliderDot.ZIndex = 2
                SliderDot.Parent = SliderBG
                AddCorner(SliderDot, UDim.new(1, 0))
                
                local currentValue = default
                local sliderDragging = false
                
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * pos
                    value = math.floor(value / increment + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    currentValue = value
                    ValueLabel.Text = tostring(value)
                    
                    local fillSize = (value - min) / (max - min)
                    CreateTween(SliderFill, {Size = UDim2.new(fillSize, 0, 1, 0)}, 0.1):Play()
                    CreateTween(SliderDot, {Position = UDim2.new(fillSize, 0, 0.5, 0)}, 0.1):Play()
                    
                    callback(value)
                end
                
                local ClickArea = Instance.new("TextButton")
                ClickArea.Name = "ClickArea"
                ClickArea.BackgroundTransparency = 1
                ClickArea.Position = UDim2.new(0, 0, 0, 18)
                ClickArea.Size = UDim2.new(1, 0, 0, 22)
                ClickArea.Text = ""
                ClickArea.Parent = SliderFrame
                
                ClickArea.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliderDragging = true
                        UpdateSlider(input)
                    end
                end)
                
                ClickArea.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        sliderDragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                local SliderObj = {}
                function SliderObj:Set(value)
                    currentValue = math.clamp(value, min, max)
                    ValueLabel.Text = tostring(currentValue)
                    local fillSize = (currentValue - min) / (max - min)
                    SliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
                    SliderDot.Position = UDim2.new(fillSize, 0, 0.5, 0)
                    callback(currentValue)
                end
                
                return SliderObj
            end
            
            -- Button Element
            function SectionObj:CreateButton(config)
                config = config or {}
                local buttonName = config.Name or "Button"
                local callback = config.Callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Name = buttonName
                Button.BackgroundColor3 = Theme.AccentPrimary
                Button.Size = UDim2.new(1, 0, 0, 30)
                Button.Font = Theme.FontMedium
                Button.Text = buttonName
                Button.TextColor3 = Theme.TextPrimary
                Button.TextSize = 12
                Button.Parent = ElementsContainer
                AddCorner(Button, Theme.CornerRadiusSmall)
                AddGradient(Button, {
                    ColorSequenceKeypoint.new(0, Theme.AccentPrimary),
                    ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
                }, 45)
                
                Button.MouseEnter:Connect(function()
                    CreateTween(Button, {Size = UDim2.new(1, 0, 0, 32)}, 0.15):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    CreateTween(Button, {Size = UDim2.new(1, 0, 0, 30)}, 0.15):Play()
                end)
                
                Button.MouseButton1Click:Connect(function()
                    CreateTween(Button, {Size = UDim2.new(0.98, 0, 0, 28)}, 0.1):Play()
                    wait(0.1)
                    CreateTween(Button, {Size = UDim2.new(1, 0, 0, 30)}, 0.1):Play()
                    callback()
                end)
                
                return Button
            end
            
            -- Label Element
            function SectionObj:CreateLabel(config)
                config = config or {}
                local labelText = config.Text or "Label"
                
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.Font = Theme.FontRegular
                Label.Text = labelText
                Label.TextColor3 = Theme.TextMuted
                Label.TextSize = 11
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Parent = ElementsContainer
                
                local LabelObj = {}
                function LabelObj:Set(text)
                    Label.Text = text
                end
                
                return LabelObj
            end
            
            return SectionObj
        end
        
        return Tab
    end
    
    -- Notification System
    function Window:Notify(config)
        config = config or {}
        local title = config.Title or "Notification"
        local message = config.Message or ""
        local duration = config.Duration or 3
        
        local NotifContainer = ScreenGui:FindFirstChild("NotifContainer")
        if not NotifContainer then
            NotifContainer = Instance.new("Frame")
            NotifContainer.Name = "NotifContainer"
            NotifContainer.BackgroundTransparency = 1
            NotifContainer.Position = UDim2.new(1, -20, 0, 20)
            NotifContainer.AnchorPoint = Vector2.new(1, 0)
            NotifContainer.Size = UDim2.new(0, 280, 1, -40)
            NotifContainer.Parent = ScreenGui
            
            local notifLayout = Instance.new("UIListLayout")
            notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
            notifLayout.Padding = UDim.new(0, 10)
            notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
            notifLayout.Parent = NotifContainer
        end
        
        local Notif = Instance.new("Frame")
        Notif.Name = "Notification"
        Notif.BackgroundColor3 = Theme.Background
        Notif.Size = UDim2.new(0, 0, 0, 60)
        Notif.ClipsDescendants = true
        Notif.Parent = NotifContainer
        AddCorner(Notif, Theme.CornerRadius)
        AddStroke(Notif, Theme.AccentPrimary, 1, 0.5)
        CreateDropShadow(Notif)
        
        local AccentBar = Instance.new("Frame")
        AccentBar.Name = "Accent"
        AccentBar.BackgroundColor3 = Theme.AccentPrimary
        AccentBar.Size = UDim2.new(0, 4, 1, 0)
        AccentBar.Parent = Notif
        AddGradient(AccentBar, {
            ColorSequenceKeypoint.new(0, Theme.AccentPrimary),
            ColorSequenceKeypoint.new(1, Theme.AccentSecondary)
        }, 90)
        
        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Name = "Title"
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Position = UDim2.new(0, 15, 0, 8)
        NotifTitle.Size = UDim2.new(1, -25, 0, 18)
        NotifTitle.Font = Theme.FontBold
        NotifTitle.Text = title
        NotifTitle.TextColor3 = Theme.AccentPrimary
        NotifTitle.TextSize = 13
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.Parent = Notif
        
        local NotifMessage = Instance.new("TextLabel")
        NotifMessage.Name = "Message"
        NotifMessage.BackgroundTransparency = 1
        NotifMessage.Position = UDim2.new(0, 15, 0, 28)
        NotifMessage.Size = UDim2.new(1, -25, 0, 25)
        NotifMessage.Font = Theme.FontRegular
        NotifMessage.Text = message
        NotifMessage.TextColor3 = Theme.TextSecondary
        NotifMessage.TextSize = 11
        NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
        NotifMessage.TextWrapped = true
        NotifMessage.Parent = Notif
        
        CreateTween(Notif, {Size = UDim2.new(0, 250, 0, 60)}, 0.3, Enum.EasingStyle.Back):Play()
        
        spawn(function()
            wait(duration)
            CreateTween(Notif, {Size = UDim2.new(0, 0, 0, 60)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
            wait(0.3)
            Notif:Destroy()
        end)
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    function Window:SetToggleKey(key)
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == key and not gameProcessed then
                MainFrame.Visible = not MainFrame.Visible
            end
        end)
    end
    
    return Window
end

return BaimlessUI
