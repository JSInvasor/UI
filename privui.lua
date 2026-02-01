--[[
    MaterialLua Enhanced v2.0
    Original by (MaterialLua author)
    Enhanced by JSInvasor
    
    New Features:
    - Image/Icon support for buttons and labels
    - ImageLabel component
    - IconButton component
    - Card component with image header
    - Avatar component
    - Badge/Notification dots
    - Progress bar
    - Divider
    - Better animations
    - Custom theme builder
    - Responsive sizing options
]]

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()

local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local InputService = game:GetService("UserInputService")
local CoreGuiService = game:GetService("CoreGui")
local ContentService = game:GetService("ContentProvider")
local HttpService = game:GetService("HttpService")

-- ═══════════════════════════════════════════════════════════════
-- THEMES
-- ═══════════════════════════════════════════════════════════════

local Themes = {
    Light = {
        MainFrame = Color3.fromRGB(255,255,255),
        Minimise = Color3.fromRGB(255,106,0),
        MinimiseAccent = Color3.fromRGB(147,59,0),
        Maximise = Color3.fromRGB(25,255,0),
        MaximiseAccent = Color3.fromRGB(0,255,110),
        NavBar = Color3.fromRGB(124,37,255),
        NavBarAccent = Color3.fromRGB(255,255,255),
        NavBarInvert = Color3.fromRGB(30,30,30),
        TitleBar = Color3.fromRGB(124,37,255),
        TitleBarAccent = Color3.fromRGB(255,255,255),
        Overlay = Color3.fromRGB(124,37,255),
        Banner = Color3.fromRGB(255,255,255),
        BannerAccent = Color3.fromRGB(124,37,255),
        Content = Color3.fromRGB(124,37,255),
        Button = Color3.fromRGB(124,37,255),
        ButtonAccent = Color3.fromRGB(255,255,255),
        ChipSet = Color3.fromRGB(124,37,255),
        ChipSetAccent = Color3.fromRGB(255,255,255),
        DataTable = Color3.fromRGB(124,37,255),
        DataTableAccent = Color3.fromRGB(255,255,255),
        Slider = Color3.fromRGB(255,255,255),
        SliderAccent = Color3.fromRGB(124,37,255),
        Toggle = Color3.fromRGB(124,37,255),
        ToggleAccent = Color3.fromRGB(255,255,255),
        Dropdown = Color3.fromRGB(255,255,255),
        DropdownAccent = Color3.fromRGB(124,37,255),
        ColorPicker = Color3.fromRGB(255,255,255),
        ColorPickerAccent = Color3.fromRGB(124,37,255),
        TextField = Color3.fromRGB(124,37,255),
        TextFieldAccent = Color3.fromRGB(124,37,255),
        -- New theme colors
        Card = Color3.fromRGB(255,255,255),
        CardAccent = Color3.fromRGB(124,37,255),
        Progress = Color3.fromRGB(124,37,255),
        ProgressBackground = Color3.fromRGB(200,200,200),
        Badge = Color3.fromRGB(255,59,48),
        Divider = Color3.fromRGB(200,200,200),
        Success = Color3.fromRGB(52,199,89),
        Warning = Color3.fromRGB(255,149,0),
        Error = Color3.fromRGB(255,59,48),
        Info = Color3.fromRGB(0,122,255),
    },
    Dark = {
        MainFrame = Color3.fromRGB(30,30,30),
        Minimise = Color3.fromRGB(255,106,0),
        MinimiseAccent = Color3.fromRGB(147,59,0),
        Maximise = Color3.fromRGB(25,255,0),
        MaximiseAccent = Color3.fromRGB(0,255,110),
        NavBar = Color3.fromRGB(55,55,55),
        NavBarAccent = Color3.fromRGB(255,255,255),
        NavBarInvert = Color3.fromRGB(235,235,235),
        TitleBar = Color3.fromRGB(55,55,55),
        TitleBarAccent = Color3.fromRGB(255,255,255),
        Overlay = Color3.fromRGB(175,175,175),
        Banner = Color3.fromRGB(55,55,55),
        BannerAccent = Color3.fromRGB(255,255,255),
        Content = Color3.fromRGB(85,85,85),
        Button = Color3.fromRGB(85,85,85),
        ButtonAccent = Color3.fromRGB(255,255,255),
        ChipSet = Color3.fromRGB(235,235,235),
        ChipSetAccent = Color3.fromRGB(85,85,85),
        DataTable = Color3.fromRGB(235,235,235),
        DataTableAccent = Color3.fromRGB(85,85,85),
        Slider = Color3.fromRGB(85,85,85),
        SliderAccent = Color3.fromRGB(235,235,235),
        Toggle = Color3.fromRGB(205,205,205),
        ToggleAccent = Color3.fromRGB(125,125,125),
        Dropdown = Color3.fromRGB(85,85,85),
        DropdownAccent = Color3.fromRGB(235,235,235),
        ColorPicker = Color3.fromRGB(85,85,85),
        ColorPickerAccent = Color3.fromRGB(235,235,235),
        TextField = Color3.fromRGB(175,175,175),
        TextFieldAccent = Color3.fromRGB(255,255,255),
        -- New theme colors
        Card = Color3.fromRGB(45,45,45),
        CardAccent = Color3.fromRGB(235,235,235),
        Progress = Color3.fromRGB(100,100,255),
        ProgressBackground = Color3.fromRGB(60,60,60),
        Badge = Color3.fromRGB(255,69,58),
        Divider = Color3.fromRGB(60,60,60),
        Success = Color3.fromRGB(48,209,88),
        Warning = Color3.fromRGB(255,159,10),
        Error = Color3.fromRGB(255,69,58),
        Info = Color3.fromRGB(10,132,255),
    },
    Midnight = {
        MainFrame = Color3.fromRGB(15,15,25),
        Minimise = Color3.fromRGB(255,100,100),
        MinimiseAccent = Color3.fromRGB(200,50,50),
        Maximise = Color3.fromRGB(100,255,100),
        MaximiseAccent = Color3.fromRGB(50,200,50),
        NavBar = Color3.fromRGB(25,25,40),
        NavBarAccent = Color3.fromRGB(200,200,255),
        NavBarInvert = Color3.fromRGB(100,100,150),
        TitleBar = Color3.fromRGB(25,25,40),
        TitleBarAccent = Color3.fromRGB(200,200,255),
        Overlay = Color3.fromRGB(50,50,80),
        Banner = Color3.fromRGB(25,25,40),
        BannerAccent = Color3.fromRGB(200,200,255),
        Content = Color3.fromRGB(35,35,55),
        Button = Color3.fromRGB(60,60,100),
        ButtonAccent = Color3.fromRGB(220,220,255),
        ChipSet = Color3.fromRGB(60,60,100),
        ChipSetAccent = Color3.fromRGB(220,220,255),
        DataTable = Color3.fromRGB(60,60,100),
        DataTableAccent = Color3.fromRGB(220,220,255),
        Slider = Color3.fromRGB(35,35,55),
        SliderAccent = Color3.fromRGB(130,130,200),
        Toggle = Color3.fromRGB(130,130,200),
        ToggleAccent = Color3.fromRGB(60,60,100),
        Dropdown = Color3.fromRGB(35,35,55),
        DropdownAccent = Color3.fromRGB(200,200,255),
        ColorPicker = Color3.fromRGB(35,35,55),
        ColorPickerAccent = Color3.fromRGB(200,200,255),
        TextField = Color3.fromRGB(50,50,80),
        TextFieldAccent = Color3.fromRGB(220,220,255),
        Card = Color3.fromRGB(25,25,40),
        CardAccent = Color3.fromRGB(200,200,255),
        Progress = Color3.fromRGB(130,130,200),
        ProgressBackground = Color3.fromRGB(40,40,60),
        Badge = Color3.fromRGB(255,100,100),
        Divider = Color3.fromRGB(50,50,80),
        Success = Color3.fromRGB(100,220,150),
        Warning = Color3.fromRGB(255,200,100),
        Error = Color3.fromRGB(255,100,100),
        Info = Color3.fromRGB(100,150,255),
    },
    Neon = {
        MainFrame = Color3.fromRGB(10,10,10),
        Minimise = Color3.fromRGB(255,0,128),
        MinimiseAccent = Color3.fromRGB(200,0,100),
        Maximise = Color3.fromRGB(0,255,128),
        MaximiseAccent = Color3.fromRGB(0,200,100),
        NavBar = Color3.fromRGB(20,20,20),
        NavBarAccent = Color3.fromRGB(0,255,255),
        NavBarInvert = Color3.fromRGB(255,0,255),
        TitleBar = Color3.fromRGB(20,20,20),
        TitleBarAccent = Color3.fromRGB(0,255,255),
        Overlay = Color3.fromRGB(30,30,30),
        Banner = Color3.fromRGB(20,20,20),
        BannerAccent = Color3.fromRGB(0,255,255),
        Content = Color3.fromRGB(25,25,25),
        Button = Color3.fromRGB(0,200,200),
        ButtonAccent = Color3.fromRGB(0,0,0),
        ChipSet = Color3.fromRGB(0,200,200),
        ChipSetAccent = Color3.fromRGB(0,0,0),
        DataTable = Color3.fromRGB(0,200,200),
        DataTableAccent = Color3.fromRGB(0,0,0),
        Slider = Color3.fromRGB(25,25,25),
        SliderAccent = Color3.fromRGB(0,255,255),
        Toggle = Color3.fromRGB(0,255,255),
        ToggleAccent = Color3.fromRGB(0,100,100),
        Dropdown = Color3.fromRGB(25,25,25),
        DropdownAccent = Color3.fromRGB(0,255,255),
        ColorPicker = Color3.fromRGB(25,25,25),
        ColorPickerAccent = Color3.fromRGB(0,255,255),
        TextField = Color3.fromRGB(30,30,30),
        TextFieldAccent = Color3.fromRGB(0,255,255),
        Card = Color3.fromRGB(20,20,20),
        CardAccent = Color3.fromRGB(0,255,255),
        Progress = Color3.fromRGB(255,0,255),
        ProgressBackground = Color3.fromRGB(40,40,40),
        Badge = Color3.fromRGB(255,0,128),
        Divider = Color3.fromRGB(0,100,100),
        Success = Color3.fromRGB(0,255,128),
        Warning = Color3.fromRGB(255,255,0),
        Error = Color3.fromRGB(255,0,128),
        Info = Color3.fromRGB(0,128,255),
    },
    Mocha = {
        MainFrame = Color3.fromRGB(255,255,255),
        Minimise = Color3.fromRGB(219, 210, 202),
        MinimiseAccent = Color3.fromRGB(219, 210, 202),
        Maximise = Color3.fromRGB(189, 183, 177),
        MaximiseAccent = Color3.fromRGB(189, 183, 177),
        NavBar = Color3.fromRGB(176, 148, 125),
        NavBarAccent = Color3.fromRGB(255,255,255),
        NavBarInvert = Color3.fromRGB(30,30,30),
        TitleBar = Color3.fromRGB(176, 148, 125),
        TitleBarAccent = Color3.fromRGB(255,255,255),
        Overlay = Color3.fromRGB(176, 148, 125),
        Banner = Color3.fromRGB(255,255,255),
        BannerAccent = Color3.fromRGB(176, 148, 125),
        Content = Color3.fromRGB(176, 148, 125),
        Button = Color3.fromRGB(176, 148, 125),
        ButtonAccent = Color3.fromRGB(255,255,255),
        ChipSet = Color3.fromRGB(176, 148, 125),
        ChipSetAccent = Color3.fromRGB(255,255,255),
        DataTable = Color3.fromRGB(176, 148, 125),
        DataTableAccent = Color3.fromRGB(255,255,255),
        Slider = Color3.fromRGB(255,255,255),
        SliderAccent = Color3.fromRGB(176, 148, 125),
        Toggle = Color3.fromRGB(176, 148, 125),
        ToggleAccent = Color3.fromRGB(255,255,255),
        Dropdown = Color3.fromRGB(255,255,255),
        DropdownAccent = Color3.fromRGB(176, 148, 125),
        ColorPicker = Color3.fromRGB(255,255,255),
        ColorPickerAccent = Color3.fromRGB(176, 148, 125),
        TextField = Color3.fromRGB(175,175,175),
        TextFieldAccent = Color3.fromRGB(255,255,255),
        Card = Color3.fromRGB(255,255,255),
        CardAccent = Color3.fromRGB(176, 148, 125),
        Progress = Color3.fromRGB(176, 148, 125),
        ProgressBackground = Color3.fromRGB(220, 210, 200),
        Badge = Color3.fromRGB(200, 100, 100),
        Divider = Color3.fromRGB(200, 190, 180),
        Success = Color3.fromRGB(120, 180, 120),
        Warning = Color3.fromRGB(220, 180, 100),
        Error = Color3.fromRGB(200, 100, 100),
        Info = Color3.fromRGB(100, 150, 200),
    },
}

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local function Lerp(a, b, t)
    return a + (b - a) * t
end

local function GetXY(GuiObject)
    local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    local Px, Py = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, Max), math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, May)
    return Px/Max, Py/May
end

local function DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- ═══════════════════════════════════════════════════════════════
-- OBJECT FACTORY
-- ═══════════════════════════════════════════════════════════════

local Types = {
    "RoundFrame",
    "Shadow",
    "Circle",
    "CircleButton",
    "Frame",
    "Label",
    "Button",
    "SmoothButton",
    "Box",
    "ScrollingFrame",
    "Menu",
    "NavBar",
    "Image",
    "ImageButton"
}

local ActualTypes = {
    RoundFrame = "ImageLabel",
    Shadow = "ImageLabel",
    Circle = "ImageLabel",
    CircleButton = "ImageButton",
    Frame = "Frame",
    Label = "TextLabel",
    Button = "TextButton",
    SmoothButton = "ImageButton",
    Box = "TextBox",
    ScrollingFrame = "ScrollingFrame",
    Menu = "ImageButton",
    NavBar = "ImageButton",
    Image = "ImageLabel",
    ImageButton = "ImageButton"
}

local Properties = {
    RoundFrame = {
        BackgroundTransparency = 1,
        Image = "http://www.roblox.com/asset/?id=5554237731",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(3,3,297,297)
    },
    SmoothButton = {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Image = "http://www.roblox.com/asset/?id=5554237731",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(3,3,297,297)
    },
    Shadow = {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "http://www.roblox.com/asset/?id=5554236805",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23,23,277,277),
        Size = UDim2.fromScale(1,1) + UDim2.fromOffset(30,30),
        Position = UDim2.fromOffset(-15,-15)
    },
    Circle = {
        BackgroundTransparency = 1,
        Image = "http://www.roblox.com/asset/?id=5554831670"
    },
    CircleButton = {
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Image = "http://www.roblox.com/asset/?id=5554831670"
    },
    Frame = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1,1)
    },
    Label = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(5,0),
        Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    },
    Button = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(5,0),
        Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    },
    Box = {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(5,0),
        Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    },
    ScrollingFrame = {
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.fromScale(0,0),
        Size = UDim2.fromScale(1,1)
    },
    Menu = {
        Name = "More",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Image = "http://www.roblox.com/asset/?id=5555108481",
        Size = UDim2.fromOffset(20,20),
        Position = UDim2.fromScale(1,0.5) - UDim2.fromOffset(25,10)
    },
    NavBar = {
        Name = "SheetToggle",
        Image = "http://www.roblox.com/asset/?id=5576439039",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(20,20),
        Position = UDim2.fromOffset(5,5),
        AutoButtonColor = false
    },
    Image = {
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit
    },
    ImageButton = {
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        ScaleType = Enum.ScaleType.Fit
    }
}

-- Common Icons (Roblox Asset IDs)
local Icons = {
    -- Navigation
    Home = "rbxassetid://7072706796",
    Settings = "rbxassetid://7072718110",
    Search = "rbxassetid://7072717857",
    Menu = "rbxassetid://7072706620",
    Back = "rbxassetid://7072705992",
    Forward = "rbxassetid://7072706147",
    Close = "rbxassetid://7072706057",
    
    -- Actions
    Add = "rbxassetid://7072705894",
    Remove = "rbxassetid://7072717758",
    Edit = "rbxassetid://7072706108",
    Delete = "rbxassetid://7072706070",
    Save = "rbxassetid://7072717809",
    Copy = "rbxassetid://7072706026",
    Paste = "rbxassetid://7072717571",
    
    -- Status
    Check = "rbxassetid://7072705999",
    Warning = "rbxassetid://7072718251",
    Error = "rbxassetid://7072706114",
    Info = "rbxassetid://7072706499",
    
    -- Media
    Play = "rbxassetid://7072717616",
    Pause = "rbxassetid://7072717557",
    Stop = "rbxassetid://7072718167",
    
    -- User
    User = "rbxassetid://7072718236",
    Users = "rbxassetid://7072718221",
    
    -- Misc
    Star = "rbxassetid://7072718140",
    Heart = "rbxassetid://7072706416",
    Lock = "rbxassetid://7072706557",
    Unlock = "rbxassetid://7072718206",
    Eye = "rbxassetid://7072706132",
    EyeOff = "rbxassetid://7072706156",
    
    -- Arrows
    ArrowUp = "rbxassetid://7072705967",
    ArrowDown = "rbxassetid://7072705908",
    ArrowLeft = "rbxassetid://7072705939",
    ArrowRight = "rbxassetid://7072705955",
    ChevronUp = "rbxassetid://7072706016",
    ChevronDown = "rbxassetid://7072706008",
    ChevronLeft = "rbxassetid://7072706012",
    ChevronRight = "rbxassetid://7072706004",
}

local function FindType(String)
    for _, Type in next, Types do
        if Type:sub(1, #String):lower() == String:lower() then
            return Type
        end
    end
    return false
end

local Objects = {}

function Objects.new(Type)
    local TargetType = FindType(Type)
    if TargetType then
        local NewInstance = Instance.new(ActualTypes[TargetType])
        if Properties[TargetType] then
            for Property, Value in next, Properties[TargetType] do
                NewInstance[Property] = Value
            end
        end
        return NewInstance
    else
        return Instance.new(Type)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- ANIMATION HELPERS
-- ═══════════════════════════════════════════════════════════════

local function CircleAnim(GuiObject, EndColour, StartColour)
    local PX, PY = GetXY(GuiObject)
    local Circle = Objects.new("Circle")
    Circle.Size = UDim2.fromScale(0,0)
    Circle.Position = UDim2.fromScale(PX,PY)
    Circle.ImageColor3 = StartColour or GuiObject.ImageColor3
    Circle.ZIndex = 200
    Circle.Parent = GuiObject
    local Size = GuiObject.AbsoluteSize.X
    TweenService:Create(Circle, TweenInfo.new(1), {
        Position = UDim2.fromScale(PX,PY) - UDim2.fromOffset(Size/2,Size/2),
        ImageTransparency = 1,
        ImageColor3 = EndColour,
        Size = UDim2.fromOffset(Size,Size)
    }):Play()
    task.spawn(function()
        task.wait(2)
        Circle:Destroy()
    end)
end

local function HoverEffect(GuiObject, HoverColor, OriginalColor, Property)
    Property = Property or "ImageColor3"
    GuiObject.MouseEnter:Connect(function()
        TweenService:Create(GuiObject, TweenInfo.new(0.2), {[Property] = HoverColor}):Play()
    end)
    GuiObject.MouseLeave:Connect(function()
        TweenService:Create(GuiObject, TweenInfo.new(0.2), {[Property] = OriginalColor}):Play()
    end)
end

local function PressEffect(GuiObject, ScaleFactor)
    ScaleFactor = ScaleFactor or 0.95
    local OriginalSize = GuiObject.Size
    
    GuiObject.MouseButton1Down:Connect(function()
        TweenService:Create(GuiObject, TweenInfo.new(0.1), {
            Size = UDim2.new(
                OriginalSize.X.Scale * ScaleFactor,
                OriginalSize.X.Offset * ScaleFactor,
                OriginalSize.Y.Scale * ScaleFactor,
                OriginalSize.Y.Offset * ScaleFactor
            )
        }):Play()
    end)
    
    GuiObject.MouseButton1Up:Connect(function()
        TweenService:Create(GuiObject, TweenInfo.new(0.1), {Size = OriginalSize}):Play()
    end)
    
    GuiObject.MouseLeave:Connect(function()
        TweenService:Create(GuiObject, TweenInfo.new(0.1), {Size = OriginalSize}):Play()
    end)
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN LIBRARY
-- ═══════════════════════════════════════════════════════════════

local Material = {}
Material.Icons = Icons
Material.Themes = Themes

local Styles = {
    [1] = "Normal",
    [2] = "Invert",
    [3] = "Sheets"
}

local ThisTheme
local MainGUI

-- Theme Builder
function Material.CreateTheme(name, colors)
    local baseTheme = DeepCopy(Themes.Dark)
    for key, value in pairs(colors) do
        baseTheme[key] = value
    end
    Themes[name] = baseTheme
    return baseTheme
end

-- Get Icon by name
function Material.GetIcon(name)
    return Icons[name] or ""
end

-- ═══════════════════════════════════════════════════════════════
-- NAVBAR STYLES
-- ═══════════════════════════════════════════════════════════════

local NavBar = {
    Normal = function()
        local NewNavBar = Objects.new("Round")
        NewNavBar.Name = "NavBar"
        NewNavBar.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-10,30)
        NewNavBar.Position = UDim2.fromOffset(5,35)
        NewNavBar.ImageColor3 = ThisTheme.NavBar
        NewNavBar.ZIndex = 100

        local NavBarShadow = Objects.new("Shadow")
        NavBarShadow.ImageColor3 = ThisTheme.NavBar
        NavBarShadow.Parent = NewNavBar
        NavBarShadow.ZIndex = 100

        local NavBarContent = Objects.new("Frame")
        NavBarContent.Name = "Content"
        NavBarContent.Parent = NewNavBar

        NavBarContent.ChildAdded:Connect(function(Child)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child, TweenInfo.new(1), {TextTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child, TweenInfo.new(1), {ImageTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child:FindFirstChildWhichIsA("ImageLabel"), TweenInfo.new(1), {ImageTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                Child.TextColor3 = ThisTheme.NavBarAccent
            end)
            pcall(function()
                Child:FindFirstChildWhichIsA("ImageLabel").ImageColor3 = ThisTheme.NavBarAccent
            end)
            pcall(function()
                Child.ImageColor3 = ThisTheme.NavBarAccent
            end)
        end)

        local NavBarList = Objects.new("UIListLayout")
        NavBarList.FillDirection = Enum.FillDirection.Horizontal
        NavBarList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        NavBarList.VerticalAlignment = Enum.VerticalAlignment.Center
        NavBarList.SortOrder = Enum.SortOrder.LayoutOrder
        NavBarList.Parent = NavBarContent

        local NavBarPadding = Objects.new("UIPadding")
        NavBarPadding.PaddingLeft = UDim.new(0,5)
        NavBarPadding.Parent = NavBarContent

        return NewNavBar, NavBarContent
    end,
    
    Invert = function()
        local NewNavBar = Objects.new("Round")
        NewNavBar.Name = "NavBar"
        NewNavBar.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-10,30)
        NewNavBar.Position = UDim2.fromOffset(5,35)
        NewNavBar.ImageColor3 = ThisTheme.NavBarAccent
        NewNavBar.ImageTransparency = 1
        NewNavBar.ZIndex = 100

        local NavBarShadow = Objects.new("Shadow")
        NavBarShadow.ImageColor3 = ThisTheme.NavBarInvert
        NavBarShadow.ImageTransparency = 1
        NavBarShadow.Parent = NewNavBar
        NavBarShadow.ZIndex = 100

        TweenService:Create(NewNavBar, TweenInfo.new(1), {ImageTransparency = 0}):Play()
        TweenService:Create(NavBarShadow, TweenInfo.new(1), {ImageTransparency = 0}):Play()

        local NavBarContent = Objects.new("Frame")
        NavBarContent.Name = "Content"
        NavBarContent.Parent = NewNavBar

        NavBarContent.ChildAdded:Connect(function(Child)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child, TweenInfo.new(1), {TextTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child, TweenInfo.new(1), {ImageTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child:FindFirstChildWhichIsA("ImageLabel"), TweenInfo.new(1), {ImageTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                Child.TextColor3 = ThisTheme.NavBar
            end)
            pcall(function()
                Child:FindFirstChildWhichIsA("ImageLabel").ImageColor3 = ThisTheme.NavBar
            end)
            pcall(function()
                Child.ImageColor3 = ThisTheme.NavBar
            end)
        end)

        local NavBarList = Objects.new("UIListLayout")
        NavBarList.FillDirection = Enum.FillDirection.Horizontal
        NavBarList.HorizontalAlignment = Enum.HorizontalAlignment.Left
        NavBarList.VerticalAlignment = Enum.VerticalAlignment.Center
        NavBarList.SortOrder = Enum.SortOrder.LayoutOrder
        NavBarList.Parent = NavBarContent

        local NavBarPadding = Objects.new("UIPadding")
        NavBarPadding.PaddingLeft = UDim.new(0,5)
        NavBarPadding.Parent = NavBarContent

        return NewNavBar, NavBarContent
    end,
    
    Sheets = function()
        local NewNavBar = Objects.new("Round")
        NewNavBar.ClipsDescendants = true
        NewNavBar.Name = "NavBar"
        NewNavBar.Size = UDim2.fromScale(0,1) - UDim2.fromOffset(0,30)
        NewNavBar.Position = UDim2.fromOffset(0,30)
        NewNavBar.ImageColor3 = ThisTheme.NavBarAccent
        NewNavBar.ZIndex = 100

        local NavBarOverlay = Objects.new("Frame")
        NavBarOverlay.Name = "Overlay"
        NavBarOverlay.BackgroundColor3 = ThisTheme.NavBar
        NavBarOverlay.BackgroundTransparency = 1
        NavBarOverlay.Size = UDim2.fromScale(1,1) - UDim2.fromOffset(0,30)
        NavBarOverlay.Position = UDim2.fromOffset(0,30)
        NavBarOverlay.ZIndex = 75

        local NavBarMenu = Objects.new("NavBar")
        NavBarMenu.ZIndex = 100

        local NavBarShadow = Objects.new("Shadow")
        NavBarShadow.ImageColor3 = ThisTheme.NavBar
        NavBarShadow.Parent = NewNavBar
        NavBarShadow.ZIndex = 100

        local Effect1, Effect2, Effect3 = Objects.new("Frame"), Objects.new("Frame"), Objects.new("Frame")

        Effect1.ZIndex = 100
        Effect2.ZIndex = 100
        Effect3.ZIndex = 100

        Effect1.BackgroundTransparency = 0
        Effect2.BackgroundTransparency = 0
        Effect3.BackgroundTransparency = 0

        Effect1.BackgroundColor3 = ThisTheme.NavBarAccent
        Effect2.BackgroundColor3 = ThisTheme.NavBarAccent
        Effect3.BackgroundColor3 = ThisTheme.NavBar

        Effect1.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,5)
        Effect2.Size = UDim2.fromScale(0,1) + UDim2.fromOffset(5,0)
        Effect3.Size = UDim2.fromScale(0,1) + UDim2.fromOffset(1,0)

        Effect1.Position = UDim2.fromScale(0,0)
        Effect2.Position = UDim2.fromScale(1,0) - UDim2.fromOffset(5,0)
        Effect3.Position = UDim2.fromScale(1,0)

        Effect1.Parent = NewNavBar
        Effect2.Parent = NewNavBar
        Effect3.Parent = NewNavBar

        local NavBarContent = Objects.new("Frame")
        NavBarContent.Name = "Content"
        NavBarContent.Parent = NewNavBar

        local NavBarList = Objects.new("UIListLayout")
        NavBarList.FillDirection = Enum.FillDirection.Vertical
        NavBarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        NavBarList.VerticalAlignment = Enum.VerticalAlignment.Top
        NavBarList.SortOrder = Enum.SortOrder.LayoutOrder
        NavBarList.Parent = NavBarContent

        local NavBarPadding = Objects.new("UIPadding")
        NavBarPadding.PaddingLeft = UDim.new(0,5)
        NavBarPadding.PaddingRight = UDim.new(0,5)
        NavBarPadding.PaddingTop = UDim.new(0,5)
        NavBarPadding.PaddingBottom = UDim.new(0,5)
        NavBarPadding.Parent = NavBarContent

        NavBarContent.ChildAdded:Connect(function(Child)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child, TweenInfo.new(1), {TextTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child, TweenInfo.new(1), {ImageTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                local Children = #NavBarContent:GetChildren() - 2
                TweenService:Create(Child:FindFirstChildWhichIsA("ImageLabel"), TweenInfo.new(1), {ImageTransparency = (Children > 1) and 0.5 or 0}):Play()
            end)
            pcall(function()
                Child.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,30)
            end)
            pcall(function()
                Child:FindFirstChildWhichIsA("ImageLabel").ImageColor3 = ThisTheme.NavBar
            end)
            pcall(function()
                Child.TextColor3 = ThisTheme.NavBar
            end)
            pcall(function()
                Child.ImageColor3 = ThisTheme.NavBar
            end)
        end)

        return NewNavBar, NavBarContent, NavBarMenu, NavBarOverlay
    end
}

-- ═══════════════════════════════════════════════════════════════
-- MENU HELPER
-- ═══════════════════════════════════════════════════════════════

local function TryAddMenu(Object, Menu, ReturnTable)
    local Menu = Menu
    local ReturnTable = ReturnTable
    ReturnTable.Object = Object
    local Total = 0

    for _, Value in pairs(Menu) do
        Total = Total + ((typeof(Value) == "function") and 1 or 0)
    end

    if Total > 0 then
        local MenuToggle = false

        local MenuButton = Objects.new("Menu")
        MenuButton.ImageTransparency = 1
        MenuButton.Parent = Object

        TweenService:Create(MenuButton, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()

        local Size = Total * 30 + ((Total + 1) * 2)

        local MenuBuild = Objects.new("Round")
        MenuBuild.Name = "Menu"
        MenuBuild.ImageColor3 = ThisTheme.ButtonAccent
        MenuBuild.Size = UDim2.fromOffset(120,0)
        MenuBuild.Position = UDim2.fromOffset(MenuButton.AbsolutePosition.X,MenuButton.AbsolutePosition.Y) - UDim2.fromOffset(125,5)
        MenuBuild.ZIndex = 100
        MenuBuild.ClipsDescendants = true
        MenuBuild.Parent = MainGUI

        MenuButton:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            MenuBuild.Position = UDim2.fromOffset(MenuButton.AbsolutePosition.X,MenuButton.AbsolutePosition.Y) - UDim2.fromOffset(125,5)
        end)

        local MenuContent = Objects.new("Frame")
        MenuContent.Name = "Content"
        MenuContent.Parent = MenuBuild

        local MenuList = Objects.new("UIListLayout")
        MenuList.Padding = UDim.new(0,2)
        MenuList.Parent = MenuContent

        local MenuPadding = Objects.new("UIPadding")
        MenuPadding.PaddingTop = UDim.new(0,2)
        MenuPadding.PaddingRight = UDim.new(0,2)
        MenuPadding.PaddingLeft = UDim.new(0,2)
        MenuPadding.PaddingBottom = UDim.new(0,2)
        MenuPadding.Parent = MenuContent

        MenuButton.MouseButton1Down:Connect(function()
            MenuToggle = not MenuToggle
            TweenService:Create(MenuBuild, TweenInfo.new(0.15), {Size = MenuToggle and UDim2.fromOffset(120,Size) or UDim2.fromOffset(120,0)}):Play()
        end)

        for Option, Value in pairs(Menu) do
            if typeof(Value) == "function" then
                local MenuOption = Objects.new("SmoothButton")
                MenuOption.Name = "MenuOption"
                MenuOption.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,30)
                MenuOption.ImageColor3 = ThisTheme.Button
                MenuOption.ImageTransparency = 1
                MenuOption.ZIndex = 150
                MenuOption.Parent = MenuContent

                local OptionShadow = Objects.new("Shadow")
                OptionShadow.ImageColor3 = ThisTheme.Button
                OptionShadow.ImageTransparency = 1
                OptionShadow.Parent = MenuOption

                local OptionValue = Objects.new("Label")
                OptionValue.Name = "Value"
                OptionValue.Position = UDim2.fromScale(0,0)
                OptionValue.Size = UDim2.fromScale(1,1) - UDim2.fromOffset(5,0)
                OptionValue.Text = Option
                OptionValue.TextColor3 = ThisTheme.Button
                OptionValue.Font = Enum.Font.Gotham
                OptionValue.TextSize = 12
                OptionValue.ZIndex = 150
                OptionValue.TextXAlignment = Enum.TextXAlignment.Right
                OptionValue.Parent = MenuOption

                MenuOption.MouseButton1Down:Connect(function()
                    Value(ReturnTable)
                    MenuToggle = false
                    TweenService:Create(MenuBuild, TweenInfo.new(0.15), {Size = UDim2.fromOffset(120,0)}):Play()
                end)

                MenuOption.MouseEnter:Connect(function()
                    TweenService:Create(MenuOption, TweenInfo.new(0.15), {ImageTransparency = 0.8}):Play()
                    TweenService:Create(OptionShadow, TweenInfo.new(0.15), {ImageTransparency = 0.8}):Play()
                end)

                MenuOption.MouseLeave:Connect(function()
                    TweenService:Create(MenuOption, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
                    TweenService:Create(OptionShadow, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
                end)
            end
        end
        return true, MenuButton
    end
    return false
end

-- ═══════════════════════════════════════════════════════════════
-- BUTTON CREATOR
-- ═══════════════════════════════════════════════════════════════

local function CreateNewButton(ButtonConfig, Parent)
    local ButtonText = ButtonConfig.Text or "nil button"
    local ButtonCallback = ButtonConfig.Callback or function() print("nil button") end
    local ButtonIcon = ButtonConfig.Icon
    local Menu = ButtonConfig.Menu or {}

    local Button = Objects.new("SmoothButton")
    Button.Name = "Button"
    Button.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,30)
    Button.ImageColor3 = ThisTheme.Button
    Button.ImageTransparency = 1
    Button.Parent = Parent

    local ButtonShadow = Objects.new("Shadow")
    ButtonShadow.ImageColor3 = ThisTheme.Button
    ButtonShadow.ImageTransparency = 1
    ButtonShadow.Parent = Button

    local ButtonLabel = Objects.new("Label")
    ButtonLabel.Text = ButtonText
    ButtonLabel.TextColor3 = ThisTheme.ButtonAccent
    ButtonLabel.Font = Enum.Font.GothamSemibold
    ButtonLabel.TextSize = 14
    ButtonLabel.ClipsDescendants = true
    ButtonLabel.TextTransparency = 1
    ButtonLabel.Parent = Button

    -- Add icon if specified
    local ButtonIconImage
    if ButtonIcon then
        ButtonIconImage = Objects.new("Image")
        ButtonIconImage.Name = "Icon"
        ButtonIconImage.Size = UDim2.fromOffset(20, 20)
        ButtonIconImage.Position = UDim2.fromOffset(5, 5)
        ButtonIconImage.ImageColor3 = ThisTheme.ButtonAccent
        ButtonIconImage.ImageTransparency = 1
        ButtonIconImage.Parent = Button
        
        -- Set icon (can be asset ID or icon name)
        if Icons[ButtonIcon] then
            ButtonIconImage.Image = Icons[ButtonIcon]
        else
            ButtonIconImage.Image = ButtonIcon
        end
        
        -- Adjust label position
        ButtonLabel.Position = UDim2.fromOffset(30, 0)
        ButtonLabel.Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(35, 0)
        
        TweenService:Create(ButtonIconImage, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
    end

    TweenService:Create(Button, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
    TweenService:Create(ButtonShadow, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
    TweenService:Create(ButtonLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    Button.MouseButton1Down:Connect(function()
        CircleAnim(ButtonLabel, ThisTheme.ButtonAccent, ThisTheme.Button)
        ButtonCallback()
    end)

    local MenuAdded = TryAddMenu(Button, Menu, {})

    return Button, ButtonLabel, ButtonIconImage
end

-- ═══════════════════════════════════════════════════════════════
-- MAIN LOAD FUNCTION
-- ═══════════════════════════════════════════════════════════════

function Material.Load(Config)
    local Style = (Config.Style and math.clamp(Config.Style, 1, 3)) or 1
    local Title = Config.Title or "MaterialLua"
    local SizeX = Config.SizeX or 300
    local SizeY = Config.SizeY or 500
    local Theme = Config.Theme or "Light"
    local Overrides = Config.ColorOverrides or {}
    local Open = true
    local Draggable = Config.Draggable ~= false

    Theme = Themes[Theme] or Themes.Light

    ThisTheme = DeepCopy(Theme)

    for KeyOverride, ValueOverride in next, Overrides do
        ThisTheme[KeyOverride] = ValueOverride
    end

    pcall(function() OldInstance:Destroy() end)

    local function GetExploit()
        local Table = {}
        Table.Synapse = syn
        Table.ProtoSmasher = pebc_create
        Table.Sentinel = issentinelclosure
        Table.ScriptWare = getexecutorname

        for ExploitName, ExploitFunction in next, Table do
            if (ExploitFunction) then
                return ExploitName
            end
        end

        return "Undefined"
    end

    local ProtectFunctions = {}
    ProtectFunctions.Synapse = function(GuiObject) syn.protect_gui(GuiObject); GuiObject.Parent = CoreGuiService end
    ProtectFunctions.ProtoSmasher = function(GuiObject) GuiObject.Parent = get_hidden_gui() end
    ProtectFunctions.Sentinel = function(GuiObject) GuiObject.Parent = CoreGuiService end
    ProtectFunctions.ScriptWare = function(GuiObject) GuiObject.Parent = gethui() end
    ProtectFunctions.Undefined = function(GuiObject) GuiObject.Parent = CoreGuiService end

    local NewInstance = Objects.new("ScreenGui")
    NewInstance.Name = Title
    ProtectFunctions[GetExploit()](NewInstance)

    getgenv().OldInstance = NewInstance

    MainGUI = NewInstance

    local MainFrame = Objects.new("Round")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.fromOffset(0,SizeY)
    MainFrame.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(SizeX/2,SizeY/2)
    MainFrame.ImageColor3 = ThisTheme.MainFrame
    MainFrame.Parent = NewInstance

    TweenService:Create(MainFrame, TweenInfo.new(1), {Size = UDim2.fromOffset(SizeX,SizeY)}):Play()

    task.wait(1)

    local MainShadow = Objects.new("Shadow")
    MainShadow.ImageColor3 = ThisTheme.MainFrame
    MainShadow.Parent = MainFrame

    local TitleBar = Objects.new("SmoothButton")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,30)
    TitleBar.ImageColor3 = ThisTheme.TitleBar
    TitleBar.ImageTransparency = 1
    TitleBar.Parent = MainFrame

    local ExtraBar = Objects.new("Frame")
    ExtraBar.Name = "Hidden"
    ExtraBar.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,5)
    ExtraBar.Position = UDim2.fromScale(0,1) - UDim2.fromOffset(0,5)
    ExtraBar.BackgroundColor3 = ThisTheme.TitleBar
    ExtraBar.Parent = TitleBar

    local TitleShadow = Objects.new("Shadow")
    TitleShadow.ImageColor3 = ThisTheme.TitleBar
    TitleShadow.ImageTransparency = 1
    TitleShadow.Parent = TitleBar

    local TitleText = Objects.new("Button")
    TitleText.Name = "Title"
    TitleText.Text = Title
    TitleText.TextColor3 = ThisTheme.TitleBarAccent
    TitleText.TextTransparency = 1
    TitleText.Font = Enum.Font.GothamBold
    TitleText.Parent = TitleBar

    if Draggable then
        TitleText.MouseButton1Down:Connect(function()
            local Mx, My = Mouse.X, Mouse.Y
            local MouseMove, MouseKill
            MouseMove = Mouse.Move:Connect(function()
                local nMx, nMy = Mouse.X, Mouse.Y
                local Dx, Dy = nMx - Mx, nMy - My
                MainFrame.Position = MainFrame.Position + UDim2.fromOffset(Dx, Dy)
                Mx, My = nMx, nMy
            end)
            MouseKill = InputService.InputEnded:Connect(function(UserInput)
                if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then
                    MouseMove:Disconnect()
                    MouseKill:Disconnect()
                end
            end)
        end)
    end

    local MinimiseButton = Objects.new("SmoothButton")
    MinimiseButton.Size = UDim2.fromOffset(20,20)
    MinimiseButton.Position = UDim2.fromScale(1,0) + UDim2.fromOffset(-25,5)
    MinimiseButton.ImageColor3 = ThisTheme.Minimise
    MinimiseButton.ImageTransparency = 1
    MinimiseButton.Parent = TitleBar

    local MinimiseShadow = Objects.new("Shadow")
    MinimiseShadow.ImageColor3 = ThisTheme.MinimiseAccent
    MinimiseShadow.ImageTransparency = 1
    MinimiseShadow.Parent = MinimiseButton

    MinimiseButton.MouseButton1Down:Connect(function()
        Open = not Open
        TweenService:Create(MainShadow, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
        TweenService:Create(MainFrame, TweenInfo.new(0.15), {Size = Open and UDim2.fromOffset(SizeX,SizeY) or UDim2.fromOffset(SizeX,30)}):Play()
        TweenService:Create(MinimiseButton, TweenInfo.new(0.15), {ImageColor3 = Open and ThisTheme.Minimise or ThisTheme.Maximise}):Play()
        TweenService:Create(MinimiseShadow, TweenInfo.new(0.15), {ImageColor3 = Open and ThisTheme.MinimiseAccent or ThisTheme.MaximiseAccent}):Play()
        if Open then
            task.wait(0.15)
            MainFrame.ClipsDescendants = false
            TweenService:Create(MainShadow, TweenInfo.new(0.15), {ImageTransparency = 0}):Play()
        else
            MainFrame.ClipsDescendants = true
        end
    end)

    local Content = Objects.new("Round")
    Content.Name = "Content"
    Content.ImageColor3 = ThisTheme.Content
    Content.Size = UDim2.fromScale(1,1) - UDim2.fromOffset(10,75)
    Content.Position = UDim2.fromOffset(5,70)
    Content.ImageTransparency = 1
    Content.Parent = MainFrame

    local NavigationBar, NavigationBarContent, NavBarMenu, NavBarOverlay = NavBar[Styles[Style]]()
    NavigationBar.Parent = MainFrame

    TweenService:Create(TitleBar, TweenInfo.new(1), {ImageTransparency = 0}):Play()
    TweenService:Create(ExtraBar, TweenInfo.new(1), {BackgroundTransparency = 0}):Play()
    TweenService:Create(TitleShadow, TweenInfo.new(1), {ImageTransparency = 0}):Play()
    TweenService:Create(TitleText, TweenInfo.new(1), {TextTransparency = 0}):Play()
    TweenService:Create(MinimiseButton, TweenInfo.new(1), {ImageTransparency = 0}):Play()
    TweenService:Create(MinimiseShadow, TweenInfo.new(1), {ImageTransparency = 0}):Play()
    TweenService:Create(Content, TweenInfo.new(1), {ImageTransparency = 0.8}):Play()

    task.wait(1)

    if NavBarMenu then
        TweenService:Create(TitleText, TweenInfo.new(0.5), {
            Size = TitleText.Size - UDim2.fromOffset(25,0),
            Position = TitleText.Position + UDim2.fromOffset(25,0)
        }):Play()
        TweenService:Create(Content, TweenInfo.new(0.5), {
            Size = Content.Size + UDim2.fromOffset(0,35),
            Position = Content.Position - UDim2.fromOffset(0,35)
        }):Play()

        NavBarMenu.ImageTransparency = 1
        NavBarMenu.Parent = TitleBar

        TweenService:Create(NavBarMenu, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()

        NavBarOverlay.Parent = MainFrame

        local MenuToggle = false

        NavBarMenu.MouseButton1Down:Connect(function()
            MenuToggle = not MenuToggle
            TweenService:Create(NavigationBar, TweenInfo.new(0.15), {Size = (MenuToggle and UDim2.fromScale(0.5,1) or UDim2.fromScale(0,1)) - UDim2.fromOffset(0,30)}):Play()
            TweenService:Create(NavBarOverlay, TweenInfo.new(0.15), {BackgroundTransparency = MenuToggle and 0.5 or 1}):Play()
            if MenuToggle then
                task.wait(0.15)
                NavigationBar.ClipsDescendants = false
            else
                NavigationBar.ClipsDescendants = true
            end
        end)
    end

    local TabCount = 0

    local TabLibrary = {}

    local ButtonTrack = {}
    local PageTrack = {}

    -- ═══════════════════════════════════════════════════════════════
    -- BANNER
    -- ═══════════════════════════════════════════════════════════════
    
    function TabLibrary.Banner(BannerConfig)
        local BannerText = BannerConfig.Text
        local BannerIcon = BannerConfig.Icon
        local BannerImage = BannerConfig.Image
        local BannerOptions = BannerConfig.Options or {}

        local ExistingBanner, ExistingBannerOverlay = MainFrame:FindFirstChild("BannerOverlay"), MainFrame:FindFirstChild("Banner")

        if ExistingBanner then
            ExistingBanner:Destroy()
        end

        if ExistingBannerOverlay then
            ExistingBannerOverlay:Destroy()
        end

        local BannerOverlay = Objects.new("Frame")
        BannerOverlay.Name = "BannerOverlay"
        BannerOverlay.BackgroundColor3 = ThisTheme.BannerAccent
        BannerOverlay.Size = UDim2.fromScale(1,1) - UDim2.fromOffset(0,30)
        BannerOverlay.Position = UDim2.fromOffset(0,30)
        BannerOverlay.ZIndex = 75
        BannerOverlay.Parent = MainFrame

        local TextSize = TextService:GetTextSize(BannerText, 12, Enum.Font.Gotham, Vector2.new(0,0)).X
        local Lines = math.ceil((TextSize) / (MainFrame.AbsoluteSize.X - 10))
        local ExtraHeight = BannerImage and 80 or 0

        local BannerSize = UDim2.fromScale(1,0) + UDim2.fromOffset(-10,(Lines*20)+40+ExtraHeight)
        local BannerPosition = UDim2.fromScale(0,1) + UDim2.fromOffset(5,(-Lines*20)-45-ExtraHeight)

        local Banner = Objects.new("Round")
        Banner.Name = "Banner"
        Banner.ImageTransparency = 1
        Banner.ImageColor3 = ThisTheme.Banner
        Banner.Size = BannerSize
        Banner.Position = BannerPosition
        Banner.ZIndex = 80
        Banner.ClipsDescendants = true
        Banner.Parent = MainFrame

        -- Add banner image if specified
        local BannerImageLabel
        if BannerImage then
            BannerImageLabel = Objects.new("Image")
            BannerImageLabel.Name = "BannerImage"
            BannerImageLabel.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, 70)
            BannerImageLabel.Position = UDim2.fromOffset(5, 5)
            BannerImageLabel.Image = BannerImage
            BannerImageLabel.ScaleType = Enum.ScaleType.Crop
            BannerImageLabel.ImageTransparency = 1
            BannerImageLabel.ZIndex = 81
            BannerImageLabel.Parent = Banner
            
            -- Add rounded corners to image
            local ImageCorner = Instance.new("UICorner")
            ImageCorner.CornerRadius = UDim.new(0, 6)
            ImageCorner.Parent = BannerImageLabel
            
            TweenService:Create(BannerImageLabel, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
        end

        local BannerLabel = Objects.new("Label")
        BannerLabel.Name = "Value"
        BannerLabel.Text = BannerText
        BannerLabel.TextColor3 = ThisTheme.BannerAccent
        BannerLabel.TextSize = 12
        BannerLabel.Font = Enum.Font.Gotham
        BannerLabel.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-5,(Lines*20)+5)
        BannerLabel.TextWrapped = true
        BannerLabel.Position = BannerImage and UDim2.fromOffset(5, 80) or UDim2.fromOffset(5,0)
        BannerLabel.TextTransparency = 1
        BannerLabel.ZIndex = 80
        BannerLabel.Parent = Banner

        -- Add icon if specified
        if BannerIcon and not BannerImage then
            local IconImage = Objects.new("Image")
            IconImage.Name = "Icon"
            IconImage.Size = UDim2.fromOffset(24, 24)
            IconImage.Position = UDim2.fromOffset(5, 5)
            IconImage.ImageColor3 = ThisTheme.BannerAccent
            IconImage.ImageTransparency = 1
            IconImage.ZIndex = 81
            IconImage.Parent = Banner
            
            if Icons[BannerIcon] then
                IconImage.Image = Icons[BannerIcon]
            else
                IconImage.Image = BannerIcon
            end
            
            BannerLabel.Position = UDim2.fromOffset(35, 0)
            BannerLabel.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-40,(Lines*20)+5)
            
            TweenService:Create(IconImage, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
        end

        TweenService:Create(BannerOverlay, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(Banner, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
        TweenService:Create(BannerLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

        local BannerContainer = Objects.new("Frame")
        BannerContainer.Name = "Options"
        BannerContainer.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-10,0)
        BannerContainer.Position = UDim2.fromScale(0,1) - UDim2.fromOffset(-5,35)
        BannerContainer.ZIndex = 80
        BannerContainer.ClipsDescendants = true
        BannerContainer.Parent = Banner

        local BannerList = Objects.new("UIListLayout")
        BannerList.FillDirection = Enum.FillDirection.Horizontal
        BannerList.HorizontalAlignment = Enum.HorizontalAlignment.Right
        BannerList.SortOrder = Enum.SortOrder.LayoutOrder
        BannerList.Padding = UDim.new(0,5)
        BannerList.Parent = BannerContainer

        BannerOptions["Ok"] = function()
            TweenService:Create(BannerContainer, TweenInfo.new(0.5), {Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-10,0)}):Play()
            TweenService:Create(BannerOverlay, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Banner, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
            TweenService:Create(BannerLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        end

        for Option, Value in pairs(BannerOptions) do
            if typeof(Value) == "function" then
                local OptionTextSize = TextService:GetTextSize(Option:upper(), 12, Enum.Font.GothamBold, Vector2.new(0,0)).X

                local OptionItem = Objects.new("SmoothButton")
                OptionItem.ImageColor3 = ThisTheme.BannerAccent
                OptionItem.ImageTransparency = 0.9
                OptionItem.Size = UDim2.fromOffset(OptionTextSize+10,30)
                OptionItem.ZIndex = 80
                OptionItem.ClipsDescendants = true
                OptionItem.Parent = BannerContainer

                local OptionLabel = Objects.new("Label")
                OptionLabel.Text = Option:upper()
                OptionLabel.TextSize = 12
                OptionLabel.TextColor3 = ThisTheme.BannerAccent
                OptionLabel.Font = Enum.Font.GothamBold
                OptionLabel.Size = UDim2.fromScale(1,1)
                OptionLabel.Position = UDim2.fromScale(0,0)
                OptionLabel.TextXAlignment = Enum.TextXAlignment.Center
                OptionLabel.ZIndex = 80
                OptionLabel.Parent = OptionItem

                OptionItem.MouseButton1Down:Connect(function()
                    Value()
                    CircleAnim(OptionItem, ThisTheme.Banner)
                end)
            end
        end

        TweenService:Create(BannerContainer, TweenInfo.new(0.5), {Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-10,30)}):Play()
    end

    -- ═══════════════════════════════════════════════════════════════
    -- NEW TAB
    -- ═══════════════════════════════════════════════════════════════
    
    function TabLibrary.New(TabConfig)
        local ImageID = TabConfig.ID
        local Title = TabConfig.Title
        local Icon = TabConfig.Icon

        local Button

        if ImageID or Icon then
            local IconImage
            
            if Icon then
                IconImage = Icons[Icon] or Icon
            elseif ImageID then
                local FetchURL = "rbxassetid://"..ImageID
                IconImage = RunService:IsStudio() and "http://www.roblox.com/asset/?id=5472131383" or game:GetObjects(FetchURL)[1].Texture
            end
            
            if Title then
                local Settings = {
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    Vector = Vector2.new(0,0)
                }

                local TextSize = TextService:GetTextSize(Title:upper(), Settings.TextSize, Settings.Font, Settings.Vector).X

                Button = Objects.new("Button")
                Button.Name = Title:upper()
                Button.TextXAlignment = Enum.TextXAlignment.Right
                Button.TextSize = Settings.TextSize
                Button.Font = Settings.Font
                Button.Text = Title:upper()
                Button.Size = UDim2.fromScale(0,1) + UDim2.fromOffset(TextSize+35, 0)
                Button.ZIndex = 200
                Button.TextTransparency = 1
                
                local NewImage = Objects.new("Round")
                NewImage.Name = "Icon"
                NewImage.BackgroundTransparency = 1
                NewImage.Size = UDim2.fromOffset(20,20)
                NewImage.ScaleType = Enum.ScaleType.Stretch
                NewImage.Image = IconImage
                NewImage.ZIndex = 200
                NewImage.ImageTransparency = 1
                NewImage.Position = UDim2.fromScale(0,0.5) - UDim2.fromOffset(0,10)
                NewImage.Parent = Button
            else
                Button = Objects.new("SmoothButton")
                Button.Name = ImageID or Icon
                Button.BackgroundTransparency = 1
                Button.Size = UDim2.fromOffset(20,20)
                Button.ScaleType = Enum.ScaleType.Stretch
                Button.Image = IconImage
                Button.ZIndex = 200
                Button.ImageTransparency = 1
            end
        else
            local Settings = {
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                Vector = Vector2.new(0,0)
            }

            local TextSize = TextService:GetTextSize(Title:upper(), Settings.TextSize, Settings.Font, Settings.Vector).X

            Button = Objects.new("Button")
            Button.Name = Title:upper()
            Button.TextXAlignment = Enum.TextXAlignment.Center
            Button.TextSize = Settings.TextSize
            Button.Font = Settings.Font
            Button.Text = Title:upper()
            Button.Size = UDim2.fromScale(0,1) + UDim2.fromOffset(TextSize+10, 0)
            Button.ZIndex = 200
            Button.TextTransparency = 1
        end

        Button.Parent = NavigationBarContent

        local PageContentFrame = Objects.new("Scroll")
        PageContentFrame.Name = Title:upper() or ImageID or Icon
        PageContentFrame.Visible = (TabCount == 0)
        PageContentFrame.ZIndex = 50
        PageContentFrame.Parent = Content

        table.insert(ButtonTrack, Button)
        table.insert(PageTrack, PageContentFrame)

        Button.MouseButton1Down:Connect(function()
            for _, Track in next, ButtonTrack do
                if not (Track == Button) then
                    TweenService:Create(Track, TweenInfo.new(0.15), {TextTransparency = 0.5}):Play()
                    pcall(function()
                        TweenService:Create(Track:FindFirstChildWhichIsA("ImageLabel"), TweenInfo.new(0.15), {ImageTransparency = 0.5}):Play()
                    end)
                else
                    TweenService:Create(Track, TweenInfo.new(0.15), {TextTransparency = 0}):Play()
                    pcall(function()
                        TweenService:Create(Track:FindFirstChildWhichIsA("ImageLabel"), TweenInfo.new(0.15), {ImageTransparency = 0}):Play()
                    end)
                end
            end
            for _, Track in next, PageTrack do
                Track.Visible = (Track == PageContentFrame)
            end
        end)

        local PagePadding = Objects.new("UIPadding")
        PagePadding.PaddingLeft = UDim.new(0,5)
        PagePadding.PaddingRight = UDim.new(0,5)
        PagePadding.PaddingTop = UDim.new(0,5)
        PagePadding.PaddingBottom = UDim.new(0,5)
        PagePadding.Parent = PageContentFrame

        local PageList = Objects.new("UIListLayout")
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Padding = UDim.new(0,5)
        PageList.Parent = PageContentFrame

        PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PageContentFrame.CanvasSize = UDim2.fromOffset(0,PageList.AbsoluteContentSize.Y+10)
        end)

        TabCount = TabCount + 1

        local OptionLibrary = {}

        -- ═══════════════════════════════════════════════════════════════
        -- BUTTON WITH ICON SUPPORT
        -- ═══════════════════════════════════════════════════════════════
        
        function OptionLibrary.Button(ButtonConfig)
            local NewButton, ButtonLabel, ButtonIcon = CreateNewButton(ButtonConfig, PageContentFrame)

            local ButtonLibrary = {}

            function ButtonLibrary:SetText(Value)
                ButtonLabel.Text = Value
            end

            function ButtonLibrary:GetText()
                return ButtonLabel.Text
            end
            
            function ButtonLibrary:SetIcon(IconName)
                if ButtonIcon then
                    if Icons[IconName] then
                        ButtonIcon.Image = Icons[IconName]
                    else
                        ButtonIcon.Image = IconName
                    end
                end
            end

            return ButtonLibrary
        end

        -- ═══════════════════════════════════════════════════════════════
        -- IMAGE LABEL - NEW COMPONENT
        -- ═══════════════════════════════════════════════════════════════
        
        function OptionLibrary.Image(ImageConfig)
            local ImageURL = ImageConfig.Image or ImageConfig.URL or ""
            local ImageSize = ImageConfig.Size or 100
            local ImageRounded = ImageConfig.Rounded ~= false
            local ImageFit = ImageConfig.Fit or "Fit" -- Fit, Crop, Stretch
            local ImageCaption = ImageConfig.Caption
            
            local CaptionHeight = ImageCaption and 25 or 0
            
            local ImageContainer = Objects.new("Round")
            ImageContainer.Name = "ImageContainer"
            ImageContainer.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(0, ImageSize + CaptionHeight)
            ImageContainer.ImageColor3 = ThisTheme.Card
            ImageContainer.ImageTransparency = 1
            ImageContainer.Parent = PageContentFrame
            
            local ImageShadow = Objects.new("Shadow")
            ImageShadow.ImageColor3 = ThisTheme.Card
            ImageShadow.ImageTransparency = 1
            ImageShadow.Parent = ImageContainer
            
            local ImageLabel = Objects.new("Image")
            ImageLabel.Name = "Image"
            ImageLabel.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, ImageSize - 10)
            ImageLabel.Position = UDim2.fromOffset(5, 5)
            ImageLabel.Image = ImageURL
            ImageLabel.ImageTransparency = 1
            ImageLabel.Parent = ImageContainer
            
            -- Set scale type
            if ImageFit == "Crop" then
                ImageLabel.ScaleType = Enum.ScaleType.Crop
            elseif ImageFit == "Stretch" then
                ImageLabel.ScaleType = Enum.ScaleType.Stretch
            else
                ImageLabel.ScaleType = Enum.ScaleType.Fit
            end
            
            -- Add rounded corners
            if ImageRounded then
                local Corner = Instance.new("UICorner")
                Corner.CornerRadius = UDim.new(0, 8)
                Corner.Parent = ImageLabel
            end
            
            -- Add caption if specified
            local CaptionLabel
            if ImageCaption then
                CaptionLabel = Objects.new("Label")
                CaptionLabel.Name = "Caption"
                CaptionLabel.Text = ImageCaption
                CaptionLabel.TextColor3 = ThisTheme.CardAccent
                CaptionLabel.TextSize = 12
                CaptionLabel.Font = Enum.Font.Gotham
                CaptionLabel.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, 20)
                CaptionLabel.Position = UDim2.fromScale(0, 1) - UDim2.fromOffset(-5, 25)
                CaptionLabel.TextXAlignment = Enum.TextXAlignment.Center
                CaptionLabel.TextTransparency = 1
                CaptionLabel.Parent = ImageContainer
                
                TweenService:Create(CaptionLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            end
            
            TweenService:Create(ImageContainer, TweenInfo.new(0.5), {ImageTransparency = 0.5}):Play()
            TweenService:Create(ImageShadow, TweenInfo.new(0.5), {ImageTransparency = 0.5}):Play()
            TweenService:Create(ImageLabel, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            
            local ImageLibrary = {}
            
            function ImageLibrary:SetImage(URL)
                ImageLabel.Image = URL
            end
            
            function ImageLibrary:GetImage()
                return ImageLabel.Image
            end
            
            function ImageLibrary:SetCaption(Text)
                if CaptionLabel then
                    CaptionLabel.Text = Text
                end
            end
            
            function ImageLibrary:SetSize(NewSize)
                TweenService:Create(ImageContainer, TweenInfo.new(0.3), {
                    Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(0, NewSize + CaptionHeight)
                }):Play()
                TweenService:Create(ImageLabel, TweenInfo.new(0.3), {
                    Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, NewSize - 10)
                }):Play()
            end
            
            return ImageLibrary
        end

        -- ═══════════════════════════════════════════════════════════════
        -- ICON BUTTON - NEW COMPONENT
        -- ═══════════════════════════════════════════════════════════════
        
        function OptionLibrary.IconButton(IconButtonConfig)
            local IconName = IconButtonConfig.Icon or "Settings"
            local IconSize = IconButtonConfig.Size or 40
            local IconCallback = IconButtonConfig.Callback or function() end
            local IconTooltip = IconButtonConfig.Tooltip
            local IconColor = IconButtonConfig.Color
            
            local IconBtn = Objects.new("CircleButton")
            IconBtn.Name = "IconButton"
            IconBtn.Size = UDim2.fromOffset(IconSize, IconSize)
            IconBtn.ImageColor3 = IconColor or ThisTheme.Button
            IconBtn.ImageTransparency = 1
            IconBtn.Parent = PageContentFrame
            
            local IconImage = Objects.new("Image")
            IconImage.Name = "Icon"
            IconImage.Size = UDim2.fromOffset(IconSize * 0.6, IconSize * 0.6)
            IconImage.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(IconSize * 0.3, IconSize * 0.3)
            IconImage.ImageColor3 = ThisTheme.ButtonAccent
            IconImage.ImageTransparency = 1
            IconImage.Parent = IconBtn
            
            if Icons[IconName] then
                IconImage.Image = Icons[IconName]
            else
                IconImage.Image = IconName
            end
            
            TweenService:Create(IconBtn, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            TweenService:Create(IconImage, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            
            -- Hover effect
            IconBtn.MouseEnter:Connect(function()
                TweenService:Create(IconBtn, TweenInfo.new(0.2), {ImageTransparency = 0.2}):Play()
            end)
            
            IconBtn.MouseLeave:Connect(function()
                TweenService:Create(IconBtn, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
            end)
            
            IconBtn.MouseButton1Down:Connect(function()
                TweenService:Create(IconBtn, TweenInfo.new(0.1), {Size = UDim2.fromOffset(IconSize * 0.9, IconSize * 0.9)}):Play()
                IconCallback()
            end)
            
            IconBtn.MouseButton1Up:Connect(function()
                TweenService:Create(IconBtn, TweenInfo.new(0.1), {Size = UDim2.fromOffset(IconSize, IconSize)}):Play()
            end)
            
            local IconBtnLibrary = {}
            
            function IconBtnLibrary:SetIcon(NewIcon)
                if Icons[NewIcon] then
                    IconImage.Image = Icons[NewIcon]
                else
                    IconImage.Image = NewIcon
                end
            end
            
            function IconBtnLibrary:SetColor(NewColor)
                TweenService:Create(IconBtn, TweenInfo.new(0.3), {ImageColor3 = NewColor}):Play()
            end
            
            return IconBtnLibrary
        end

        -- ═══════════════════════════════════════════════════════════════
        -- CARD WITH IMAGE - NEW COMPONENT
        -- ═══════════════════════════════════════════════════════════════
        
        function OptionLibrary.Card(CardConfig)
            local CardTitle = CardConfig.Title or "Card"
            local CardDescription = CardConfig.Description or ""
            local CardImage = CardConfig.Image
            local CardImageHeight = CardConfig.ImageHeight or 80
            local CardCallback = CardConfig.Callback
            local CardButtons = CardConfig.Buttons or {}
            
            local DescLines = math.ceil(TextService:GetTextSize(CardDescription, 12, Enum.Font.Gotham, Vector2.new(0,0)).X / 200)
            local TotalHeight = 35 + (CardImage and CardImageHeight or 0) + (DescLines * 16) + (#CardButtons > 0 and 35 or 0)
            
            local Card = Objects.new("Round")
            Card.Name = "Card"
            Card.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(0, TotalHeight)
            Card.ImageColor3 = ThisTheme.Card
            Card.ImageTransparency = 1
            Card.ClipsDescendants = true
            Card.Parent = PageContentFrame
            
            local CardShadow = Objects.new("Shadow")
            CardShadow.ImageColor3 = ThisTheme.Card
            CardShadow.ImageTransparency = 1
            CardShadow.Parent = Card
            
            local YOffset = 5
            
            -- Card Image
            if CardImage then
                local CardImageLabel = Objects.new("Image")
                CardImageLabel.Name = "CardImage"
                CardImageLabel.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, CardImageHeight)
                CardImageLabel.Position = UDim2.fromOffset(5, YOffset)
                CardImageLabel.Image = CardImage
                CardImageLabel.ScaleType = Enum.ScaleType.Crop
                CardImageLabel.ImageTransparency = 1
                CardImageLabel.Parent = Card
                
                local ImageCorner = Instance.new("UICorner")
                ImageCorner.CornerRadius = UDim.new(0, 6)
                ImageCorner.Parent = CardImageLabel
                
                TweenService:Create(CardImageLabel, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
                
                YOffset = YOffset + CardImageHeight + 5
            end
            
            -- Card Title
            local CardTitleLabel = Objects.new("Label")
            CardTitleLabel.Name = "Title"
            CardTitleLabel.Text = CardTitle
            CardTitleLabel.TextColor3 = ThisTheme.CardAccent
            CardTitleLabel.TextSize = 16
            CardTitleLabel.Font = Enum.Font.GothamBold
            CardTitleLabel.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, 20)
            CardTitleLabel.Position = UDim2.fromOffset(5, YOffset)
            CardTitleLabel.TextTransparency = 1
            CardTitleLabel.Parent = Card
            
            YOffset = YOffset + 22
            
            -- Card Description
            if CardDescription ~= "" then
                local CardDescLabel = Objects.new("Label")
                CardDescLabel.Name = "Description"
                CardDescLabel.Text = CardDescription
                CardDescLabel.TextColor3 = ThisTheme.CardAccent
                CardDescLabel.TextSize = 12
                CardDescLabel.Font = Enum.Font.Gotham
                CardDescLabel.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, DescLines * 16)
                CardDescLabel.Position = UDim2.fromOffset(5, YOffset)
                CardDescLabel.TextWrapped = true
                CardDescLabel.TextTransparency = 1
                CardDescLabel.Parent = Card
                
                TweenService:Create(CardDescLabel, TweenInfo.new(0.5), {TextTransparency = 0.3}):Play()
                
                YOffset = YOffset + (DescLines * 16) + 5
            end
            
            -- Card Buttons
            if #CardButtons > 0 then
                local ButtonContainer = Objects.new("Frame")
                ButtonContainer.Name = "Buttons"
                ButtonContainer.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, 30)
                ButtonContainer.Position = UDim2.fromOffset(5, YOffset)
                ButtonContainer.Parent = Card
                
                local ButtonList = Objects.new("UIListLayout")
                ButtonList.FillDirection = Enum.FillDirection.Horizontal
                ButtonList.HorizontalAlignment = Enum.HorizontalAlignment.Right
                ButtonList.Padding = UDim.new(0, 5)
                ButtonList.Parent = ButtonContainer
                
                for _, BtnConfig in ipairs(CardButtons) do
                    local BtnTextSize = TextService:GetTextSize(BtnConfig.Text:upper(), 11, Enum.Font.GothamBold, Vector2.new(0,0)).X
                    
                    local CardBtn = Objects.new("SmoothButton")
                    CardBtn.Size = UDim2.fromOffset(BtnTextSize + 20, 25)
                    CardBtn.ImageColor3 = BtnConfig.Color or ThisTheme.CardAccent
                    CardBtn.ImageTransparency = 0.8
                    CardBtn.Parent = ButtonContainer
                    
                    local BtnLabel = Objects.new("Label")
                    BtnLabel.Text = BtnConfig.Text:upper()
                    BtnLabel.TextColor3 = ThisTheme.CardAccent
                    BtnLabel.TextSize = 11
                    BtnLabel.Font = Enum.Font.GothamBold
                    BtnLabel.TextXAlignment = Enum.TextXAlignment.Center
                    BtnLabel.Size = UDim2.fromScale(1, 1)
                    BtnLabel.Position = UDim2.fromOffset(0, 0)
                    BtnLabel.Parent = CardBtn
                    
                    CardBtn.MouseButton1Down:Connect(function()
                        if BtnConfig.Callback then
                            BtnConfig.Callback()
                        end
                    end)
                    
                    CardBtn.MouseEnter:Connect(function()
                        TweenService:Create(CardBtn, TweenInfo.new(0.2), {ImageTransparency = 0.6}):Play()
                    end)
                    
                    CardBtn.MouseLeave:Connect(function()
                        TweenService:Create(CardBtn, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
                    end)
                end
            end
            
            TweenService:Create(Card, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            TweenService:Create(CardShadow, TweenInfo.new(0.5), {ImageTransparency = 0.3}):Play()
            TweenService:Create(CardTitleLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            
            -- Make card clickable if callback provided
            if CardCallback then
                local CardButton = Objects.new("SmoothButton")
                CardButton.Size = UDim2.fromScale(1, 1)
                CardButton.ImageTransparency = 1
                CardButton.ZIndex = 50
                CardButton.Parent = Card
                
                CardButton.MouseButton1Down:Connect(CardCallback)
            end
            
            local CardLibrary = {}
            
            function CardLibrary:SetTitle(Text)
                CardTitleLabel.Text = Text
            end
            
            return CardLibrary
        end

        -- ═══════════════════════════════════════════════════════════════
        -- AVATAR - NEW COMPONENT
        -- ═══════════════════════════════════════════════════════════════
        
        function OptionLibrary.Avatar(AvatarConfig)
            local AvatarImage = AvatarConfig.Image or ""
            local AvatarSize = AvatarConfig.Size or 60
            local AvatarName = AvatarConfig.Name
            local AvatarStatus = AvatarConfig.Status -- "online", "offline", "away", "busy"
            local AvatarCallback = AvatarConfig.Callback
            
            local TotalHeight = AvatarSize + (AvatarName and 20 or 0)
            
            local AvatarContainer = Objects.new("Frame")
            AvatarContainer.Name = "AvatarContainer"
            AvatarContainer.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(0, TotalHeight)
            AvatarContainer.Parent = PageContentFrame
            
            local AvatarFrame = Objects.new("CircleButton")
            AvatarFrame.Name = "Avatar"
            AvatarFrame.Size = UDim2.fromOffset(AvatarSize, AvatarSize)
            AvatarFrame.Position = UDim2.fromScale(0.5, 0) - UDim2.fromOffset(AvatarSize / 2, 0)
            AvatarFrame.ImageColor3 = Color3.fromRGB(255, 255, 255)
            AvatarFrame.Image = AvatarImage
            AvatarFrame.ImageTransparency = 1
            AvatarFrame.Parent = AvatarContainer
            
            -- Status indicator
            if AvatarStatus then
                local StatusColors = {
                    online = ThisTheme.Success,
                    offline = Color3.fromRGB(128, 128, 128),
                    away = ThisTheme.Warning,
                    busy = ThisTheme.Error
                }
                
                local StatusDot = Objects.new("Circle")
                StatusDot.Name = "Status"
                StatusDot.Size = UDim2.fromOffset(AvatarSize * 0.25, AvatarSize * 0.25)
                StatusDot.Position = UDim2.fromScale(1, 1) - UDim2.fromOffset(AvatarSize * 0.3, AvatarSize * 0.3)
                StatusDot.ImageColor3 = StatusColors[AvatarStatus] or StatusColors.offline
                StatusDot.ImageTransparency = 1
                StatusDot.ZIndex = 5
                StatusDot.Parent = AvatarFrame
                
                TweenService:Create(StatusDot, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            end
            
            -- Name label
            local NameLabel
            if AvatarName then
                NameLabel = Objects.new("Label")
                NameLabel.Name = "Name"
                NameLabel.Text = AvatarName
                NameLabel.TextColor3 = ThisTheme.CardAccent
                NameLabel.TextSize = 14
                NameLabel.Font = Enum.Font.GothamSemibold
                NameLabel.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(0, 20)
                NameLabel.Position = UDim2.fromOffset(0, AvatarSize + 5)
                NameLabel.TextXAlignment = Enum.TextXAlignment.Center
                NameLabel.TextTransparency = 1
                NameLabel.Parent = AvatarContainer
                
                TweenService:Create(NameLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            end
            
            TweenService:Create(AvatarFrame, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            
            if AvatarCallback then
                AvatarFrame.MouseButton1Down:Connect(AvatarCallback)
            end
            
            local AvatarLibrary = {}
            
            function AvatarLibrary:SetImage(URL)
                AvatarFrame.Image = URL
            end
            
            function AvatarLibrary:SetStatus(Status)
                local StatusColors = {
                    online = ThisTheme.Success,
                    offline = Color3.fromRGB(128, 128, 128),
                    away = ThisTheme.Warning,
                    busy = ThisTheme.Error
                }
                local StatusDot = AvatarFrame:FindFirstChild("Status")
                if StatusDot then
                    TweenService:Create(StatusDot, TweenInfo.new(0.3), {ImageColor3 = StatusColors[Status] or StatusColors.offline}):Play()
                end
            end
            
            function AvatarLibrary:SetName(Name)
                if NameLabel then
                    NameLabel.Text = Name
                end
            end
            
            return AvatarLibrary
        end

        -- ═══════════════════════════════════════════════════════════════
        -- PROGRESS BAR - NEW COMPONENT
        -- ═══════════════════════════════════════════════════════════════
        
        function OptionLibrary.Progress(ProgressConfig)
            local ProgressText = ProgressConfig.Text or "Progress"
            local ProgressValue = ProgressConfig.Value or 0
            local ProgressMax = ProgressConfig.Max or 100
            local ProgressShowPercent = ProgressConfig.ShowPercent ~= false
            local ProgressColor = ProgressConfig.Color
            local ProgressAnimated = ProgressConfig.Animated
            
            local Progress = Objects.new("Round")
            Progress.Name = "Progress"
            Progress.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(0, 45)
            Progress.ImageColor3 = ThisTheme.Card
            Progress.ImageTransparency = 1
            Progress.Parent = PageContentFrame
            
            local ProgressLabel = Objects.new("Label")
            ProgressLabel.Name = "Label"
            ProgressLabel.Text = ProgressText
            ProgressLabel.TextColor3 = ThisTheme.CardAccent
            ProgressLabel.TextSize = 14
            ProgressLabel.Font = Enum.Font.GothamSemibold
            ProgressLabel.Size = UDim2.fromScale(0.7, 0) + UDim2.fromOffset(0, 20)
            ProgressLabel.Position = UDim2.fromOffset(5, 5)
            ProgressLabel.TextTransparency = 1
            ProgressLabel.Parent = Progress
            
            local PercentLabel
            if ProgressShowPercent then
                PercentLabel = Objects.new("Label")
                PercentLabel.Name = "Percent"
                PercentLabel.Text = math.floor((ProgressValue / ProgressMax) * 100) .. "%"
                PercentLabel.TextColor3 = ThisTheme.CardAccent
                PercentLabel.TextSize = 14
                PercentLabel.Font = Enum.Font.GothamSemibold
                PercentLabel.Size = UDim2.fromScale(0.3, 0) + UDim2.fromOffset(-10, 20)
                PercentLabel.Position = UDim2.fromScale(0.7, 0) + UDim2.fromOffset(0, 5)
                PercentLabel.TextXAlignment = Enum.TextXAlignment.Right
                PercentLabel.TextTransparency = 1
                PercentLabel.Parent = Progress
                
                TweenService:Create(PercentLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            end
            
            local ProgressTrack = Objects.new("Round")
            ProgressTrack.Name = "Track"
            ProgressTrack.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-10, 10)
            ProgressTrack.Position = UDim2.fromOffset(5, 30)
            ProgressTrack.ImageColor3 = ThisTheme.ProgressBackground
            ProgressTrack.ImageTransparency = 1
            ProgressTrack.Parent = Progress
            
            local ProgressFill = Objects.new("Round")
            ProgressFill.Name = "Fill"
            ProgressFill.Size = UDim2.fromScale(ProgressValue / ProgressMax, 1)
            ProgressFill.ImageColor3 = ProgressColor or ThisTheme.Progress
            ProgressFill.ImageTransparency = 1
            ProgressFill.Parent = ProgressTrack
            
            TweenService:Create(Progress, TweenInfo.new(0.5), {ImageTransparency = 0.5}):Play()
            TweenService:Create(ProgressLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            TweenService:Create(ProgressTrack, TweenInfo.new(0.5), {ImageTransparency = 0.5}):Play()
            TweenService:Create(ProgressFill, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            
            -- Animated shimmer effect
            if ProgressAnimated then
                task.spawn(function()
                    while Progress.Parent do
                        TweenService:Create(ProgressFill, TweenInfo.new(1), {ImageTransparency = 0.3}):Play()
                        task.wait(1)
                        TweenService:Create(ProgressFill, TweenInfo.new(1), {ImageTransparency = 0}):Play()
                        task.wait(1)
                    end
                end)
            end
            
            local ProgressLibrary = {}
            
            function ProgressLibrary:SetValue(Value)
                ProgressValue = math.clamp(Value, 0, ProgressMax)
                TweenService:Create(ProgressFill, TweenInfo.new(0.3), {
                    Size = UDim2.fromScale(ProgressValue / ProgressMax, 1)
                }):Play()
                if PercentLabel then
                    PercentLabel.Text = math.floor((ProgressValue / ProgressMax) * 100) .. "%"
                end
            end
            
            function ProgressLibrary:GetValue()
                return ProgressValue
            end
            
            function ProgressLibrary:SetMax(Value)
                ProgressMax = Value
                ProgressLibrary:SetValue(ProgressValue)
            end
            
            function ProgressLibrary:SetText(Text)
                ProgressLabel.Text = Text
            end
            
            function ProgressLibrary:SetColor(Color)
                TweenService:Create(ProgressFill, TweenInfo.new(0.3), {ImageColor3 = Color}):Play()
            end
            
            return ProgressLibrary
        end

        -- ═══════════════════════════════════════════════════════════════
        -- DIVIDER - NEW COMPONENT
        -- ═══════════════════════════════════════════════════════════════
        
        function OptionLibrary.Divider(DividerConfig)
            DividerConfig = DividerConfig or {}
            local DividerText = DividerConfig.Text
            local DividerColor = DividerConfig.Color or ThisTheme.Divider
            
            local DividerHeight = DividerText and 20 or 10
            
            local DividerContainer = Objects.new("Frame")
            DividerContainer.Name = "Divider"
            DividerContainer.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(0, DividerHeight)
            DividerContainer.Parent = PageContentFrame
            
            if DividerText then
                local LeftLine = Objects.new("Frame")
                LeftLine.Size = UDim2.fromScale(0.3, 0) + UDim2.fromOffset(0, 1)
                LeftLine.Position = UDim2.fromScale(0, 0.5)
                LeftLine.BackgroundColor3 = DividerColor
                LeftLine.BackgroundTransparency = 0.5
                LeftLine.Parent = DividerContainer
                
                local DividerLabel = Objects.new("Label")
                DividerLabel.Text = DividerText
                DividerLabel.TextColor3 = DividerColor
                DividerLabel.TextSize = 12
                DividerLabel.Font = Enum.Font.Gotham
                DividerLabel.Size = UDim2.fromScale(0.4, 1)
                DividerLabel.Position = UDim2.fromScale(0.3, 0)
                DividerLabel.TextXAlignment = Enum.TextXAlignment.Center
                DividerLabel.Parent = DividerContainer
                
                local RightLine = Objects.new("Frame")
                RightLine.Size = UDim2.fromScale(0.3, 0) + UDim2.fromOffset(0, 1)
                RightLine.Position = UDim2.fromScale(0.7, 0.5)
                RightLine.BackgroundColor3 = DividerColor
                RightLine.BackgroundTransparency = 0.5
                RightLine.Parent = DividerContainer
            else
                local Line = Objects.new("Frame")
                Line.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(0, 1)
                Line.Position = UDim2.fromScale(0, 0.5)
                Line.BackgroundColor3 = DividerColor
                Line.BackgroundTransparency = 0.5
                Line.Parent = DividerContainer
            end
            
            return {}
        end

        -- ═══════════════════════════════════════════════════════════════
        -- EXISTING COMPONENTS (Dropdown, Toggle, Slider, etc.)
        -- Keeping them but with Icon support where applicable
        -- ═══════════════════════════════════════════════════════════════
        
        function OptionLibrary.Dropdown(DropdownConfig)
            local DropdownText = DropdownConfig.Text or "nil dropdown"
            local DropdownValue = DropdownConfig.Default
            local DropdownCallback = DropdownConfig.Callback or function() print("nil dropdown") end
            local DropdownOptions = DropdownConfig.Options or {}
            local DropdownIcon = DropdownConfig.Icon
            local Menu = DropdownConfig.Menu or {}

            local Dropdown = Objects.new("Frame")
            Dropdown.Name = "Dropdown"
            Dropdown.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,30)
            Dropdown.Parent = PageContentFrame

            local DropdownBar = Objects.new("Round")
            DropdownBar.Name = "TitleBar"
            DropdownBar.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,30)
            DropdownBar.ImageColor3 = ThisTheme.Dropdown
            DropdownBar.ImageTransparency = 1
            DropdownBar.Parent = Dropdown

            local DropdownTitle = Objects.new("Button")
            DropdownTitle.Name = "Title"
            DropdownTitle.Font = Enum.Font.GothamSemibold
            DropdownTitle.Text = DropdownValue and DropdownText..": "..DropdownValue or DropdownText
            DropdownTitle.TextColor3 = ThisTheme.DropdownAccent
            DropdownTitle.TextTransparency = 1
            DropdownTitle.TextSize = 14
            DropdownTitle.Parent = DropdownBar
            
            -- Add icon if specified
            if DropdownIcon then
                local IconImg = Objects.new("Image")
                IconImg.Name = "Icon"
                IconImg.Size = UDim2.fromOffset(18, 18)
                IconImg.Position = UDim2.fromOffset(5, 6)
                IconImg.ImageColor3 = ThisTheme.DropdownAccent
                IconImg.ImageTransparency = 1
                IconImg.Parent = DropdownBar
                
                if Icons[DropdownIcon] then
                    IconImg.Image = Icons[DropdownIcon]
                else
                    IconImg.Image = DropdownIcon
                end
                
                DropdownTitle.Position = UDim2.fromOffset(28, 0)
                DropdownTitle.Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(33, 0)
                
                TweenService:Create(IconImg, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            end

            local DropdownToggle = Objects.new("Round")
            DropdownToggle.Name = "Container"
            DropdownToggle.Size = UDim2.fromOffset(24,24)
            DropdownToggle.Position = UDim2.fromScale(1,0.5) - UDim2.fromOffset(27,12)
            DropdownToggle.ImageColor3 = ThisTheme.DropdownAccent
            DropdownToggle.ImageTransparency = 1
            DropdownToggle.Parent = DropdownBar

            local DropdownButton = Objects.new("Round")
            DropdownButton.Name = "Drop"
            DropdownButton.Image = "http://www.roblox.com/asset/?id=5574299686"
            DropdownButton.ScaleType = Enum.ScaleType.Stretch
            DropdownButton.Size = UDim2.fromScale(1,1) - UDim2.fromOffset(4,4)
            DropdownButton.Position = UDim2.fromOffset(2,2)
            DropdownButton.ImageColor3 = ThisTheme.DropdownAccent
            DropdownButton.ImageTransparency = 1
            DropdownButton.Parent = DropdownToggle

            TweenService:Create(DropdownBar, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            TweenService:Create(DropdownTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            TweenService:Create(DropdownToggle, TweenInfo.new(0.5), {ImageTransparency = 0.8}):Play()
            TweenService:Create(DropdownButton, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()

            local DropdownContent = Objects.new("Frame")
            DropdownContent.Name = "Content"
            DropdownContent.Size = UDim2.fromScale(1,0)
            DropdownContent.Position = UDim2.fromOffset(0,35)
            DropdownContent.ClipsDescendants = true
            DropdownContent.Parent = Dropdown

            local NumberOfOptions = #DropdownOptions
            local DropToggle = false
            local DropdownSize = UDim2.fromScale(1,0) + UDim2.fromOffset(0,(NumberOfOptions*20) + ((NumberOfOptions - 1) * 5))

            local DropdownList = Objects.new("UIListLayout")
            DropdownList.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownList.Padding = UDim.new(0,5)
            DropdownList.Parent = DropdownContent

            DropdownList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if DropToggle then
                    DropdownContent.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0, DropdownList.AbsoluteContentSize.Y)
                    DropdownSize = UDim2.fromScale(1,0) + UDim2.fromOffset(0, DropdownList.AbsoluteContentSize.Y)
                end
            end)

            for _, Value in ipairs(DropdownOptions) do
                local NewButton = CreateNewButton({
                    Text = Value,
                    Callback = function() end
                }, DropdownContent)

                NewButton.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,20)
                NewButton.MouseButton1Down:Connect(function()
                    DropdownCallback(Value)
                    DropdownTitle.Text = DropdownText..": "..Value
                    DropdownValue = Value
                end)
            end

            DropdownTitle.MouseButton1Down:Connect(function()
                DropToggle = not DropToggle
                TweenService:Create(DropdownButton, TweenInfo.new(0.15), {Rotation = DropToggle and 135 or 0}):Play()
                TweenService:Create(DropdownContent, TweenInfo.new(0.15), {Size = DropToggle and DropdownSize or UDim2.fromScale(1,0)}):Play()
                TweenService:Create(Dropdown, TweenInfo.new(0.15), {Size = DropToggle and (DropdownSize + UDim2.fromOffset(0,35)) or (UDim2.fromScale(1,0) + UDim2.fromOffset(0,30))}):Play()
            end)

            local MenuAdded, MenuButton = TryAddMenu(DropdownBar, Menu, {})

            if MenuAdded then
                DropdownToggle.Position = DropdownToggle.Position - UDim2.fromOffset(25,0)
                MenuButton.ImageColor3 = ThisTheme.DropdownAccent
            end

            local DropdownLibrary = {}

            function DropdownLibrary:SetText(Value)
                DropdownTitle.Text = Value
            end

            function DropdownLibrary:GetText()
                return DropdownTitle.Text
            end

            function DropdownLibrary:GetValue()
                return DropdownValue
            end

            function DropdownLibrary:SetOptions(NewMenu)
                DropdownOptions = NewMenu or {}
                NumberOfOptions = #DropdownOptions
                DropdownSize = UDim2.fromScale(1,0) + UDim2.fromOffset(0,(NumberOfOptions*20) + ((NumberOfOptions - 1) * 5))

                if DropdownContent then
                    DropdownContent:Destroy()
                end

                TweenService:Create(Dropdown, TweenInfo.new(0.15), {Size = DropToggle and (DropdownSize + UDim2.fromOffset(0,35)) or (UDim2.fromScale(1,0) + UDim2.fromOffset(0,30))}):Play()

                DropdownContent = Objects.new("Frame")
                DropdownContent.Name = "Content"
                DropdownContent.Size = DropToggle and DropdownSize or UDim2.fromScale(1,0)
                DropdownContent.Position = UDim2.fromOffset(0,35)
                DropdownContent.ClipsDescendants = true
                DropdownContent.Parent = Dropdown

                local NewDropdownList = Objects.new("UIListLayout")
                NewDropdownList.SortOrder = Enum.SortOrder.LayoutOrder
                NewDropdownList.Padding = UDim.new(0,5)
                NewDropdownList.Parent = DropdownContent

                for _, Value in ipairs(DropdownOptions) do
                    local NewBtn = CreateNewButton({
                        Text = Value,
                        Callback = function() end
                    }, DropdownContent)

                    NewBtn.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,20)
                    NewBtn.MouseButton1Down:Connect(function()
                        DropdownCallback(Value)
                        DropdownTitle.Text = DropdownText..": "..Value
                        DropdownValue = Value
                    end)
                end
            end

            function DropdownLibrary:GetOptions()
                return DropdownOptions
            end

            if DropdownOptions.Default then
                DropdownTitle.Text = DropdownText..": "..DropdownOptions.Default
            end

            return DropdownLibrary
        end

        function OptionLibrary.Toggle(ToggleConfig)
            local ToggleText = ToggleConfig.Text or "nil toggle"
            local ToggleCallback = ToggleConfig.Callback or function() print("nil toggle") end
            local ToggleDefault = ToggleConfig.Enabled or false
            local ToggleIcon = ToggleConfig.Icon
            local Menu = ToggleConfig.Menu or {}

            local Toggle = Objects.new("SmoothButton")
            Toggle.Name = "Toggle"
            Toggle.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,30)
            Toggle.ImageColor3 = ThisTheme.Toggle
            Toggle.ImageTransparency = 1
            Toggle.Parent = PageContentFrame

            local ToggleTracker = Objects.new("Round")
            ToggleTracker.Name = "Tracker"
            ToggleTracker.Image = "rbxassetid://3570695787"
            ToggleTracker.SliceCenter = Rect.new(100,100,100,100)
            ToggleTracker.SliceScale = 1
            ToggleTracker.Size = UDim2.fromOffset(26,12)
            ToggleTracker.Position = UDim2.fromScale(1,0.5) - UDim2.fromOffset(41,6)
            ToggleTracker.ImageColor3 = ThisTheme.Toggle
            ToggleTracker.ImageTransparency = 1
            ToggleTracker.Parent = Toggle

            local Dot = Objects.new("Circle")
            Dot.Name = "Dot"
            Dot.Size = UDim2.fromOffset(16,16)
            Dot.Position = UDim2.fromScale(0,0.5) - UDim2.fromOffset(8,8)
            Dot.ImageColor3 = ThisTheme.ToggleAccent
            Dot.ImageTransparency = 1
            Dot.Parent = ToggleTracker

            local DotShadow = Objects.new("Round")
            DotShadow.Name = "Shadow"
            DotShadow.Image = "http://www.roblox.com/asset/?id=5554831957"
            DotShadow.ScaleType = Enum.ScaleType.Stretch
            DotShadow.Size = UDim2.fromOffset(31,31)
            DotShadow.Position = UDim2.fromOffset(-8,-8)
            DotShadow.ImageColor3 = ThisTheme.Toggle
            DotShadow.ImageTransparency = 1
            DotShadow.Parent = Dot

            local ToggleLabel = Objects.new("Label")
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextSize = 14
            ToggleLabel.Text = ToggleText
            ToggleLabel.TextColor3 = ThisTheme.Toggle
            ToggleLabel.TextTransparency = 1
            ToggleLabel.ClipsDescendants = true
            ToggleLabel.Parent = Toggle
            
            -- Add icon if specified
            if ToggleIcon then
                local IconImg = Objects.new("Image")
                IconImg.Name = "Icon"
                IconImg.Size = UDim2.fromOffset(18, 18)
                IconImg.Position = UDim2.fromOffset(5, 6)
                IconImg.ImageColor3 = ThisTheme.Toggle
                IconImg.ImageTransparency = 1
                IconImg.Parent = Toggle
                
                if Icons[ToggleIcon] then
                    IconImg.Image = Icons[ToggleIcon]
                else
                    IconImg.Image = ToggleIcon
                end
                
                ToggleLabel.Position = UDim2.fromOffset(28, 0)
                ToggleLabel.Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(33, 0)
                
                TweenService:Create(IconImg, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            end

            TweenService:Create(Toggle, TweenInfo.new(0.5), {ImageTransparency = 0.8}):Play()
            TweenService:Create(ToggleTracker, TweenInfo.new(0.5), {ImageTransparency = 0.5}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            TweenService:Create(DotShadow, TweenInfo.new(0.5), {ImageTransparency = 0.5}):Play()
            TweenService:Create(ToggleLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

            TweenService:Create(Dot, TweenInfo.new(0.15), {Position = (ToggleDefault and UDim2.fromScale(1,0.5) or UDim2.fromScale(0,0.5)) - UDim2.fromOffset(8,8), ImageColor3 = ToggleDefault and ThisTheme.Toggle or ThisTheme.ToggleAccent}):Play()
            ToggleCallback(ToggleDefault)

            Toggle.MouseButton1Down:Connect(function()
                ToggleDefault = not ToggleDefault
                TweenService:Create(Dot, TweenInfo.new(0.15), {Position = (ToggleDefault and UDim2.fromScale(1,0.5) or UDim2.fromScale(0,0.5)) - UDim2.fromOffset(8,8), ImageColor3 = ToggleDefault and ThisTheme.Toggle or ThisTheme.ToggleAccent}):Play()
                ToggleCallback(ToggleDefault)
                CircleAnim(ToggleLabel, ThisTheme.ToggleAccent, ThisTheme.Toggle)
            end)

            local MenuAdded, MenuButton = TryAddMenu(Toggle, Menu, {})

            if MenuAdded then
                ToggleTracker.Position = ToggleTracker.Position - UDim2.fromOffset(15,0)
                MenuButton.ImageColor3 = ThisTheme.Toggle
            end

            local ToggleLibrary = {}

            function ToggleLibrary:SetText(Value)
                ToggleLabel.Text = Value
            end

            function ToggleLibrary:GetText()
                return ToggleLabel.Text
            end

            function ToggleLibrary:SetState(Value)
                ToggleDefault = Value
                TweenService:Create(Dot, TweenInfo.new(0.15), {Position = (ToggleDefault and UDim2.fromScale(1,0.5) or UDim2.fromScale(0,0.5)) - UDim2.fromOffset(8,8), ImageColor3 = ToggleDefault and ThisTheme.Toggle or ThisTheme.ToggleAccent}):Play()
                ToggleCallback(ToggleDefault)
            end

            function ToggleLibrary:GetState()
                return ToggleDefault
            end

            return ToggleLibrary
        end

        function OptionLibrary.Slider(SliderConfig)
            local SliderText = SliderConfig.Text or "nil slider"
            local SliderCallback = SliderConfig.Callback or function() print("nil slider") end
            local SliderMin = SliderConfig.Min or 0
            local SliderMax = SliderConfig.Max or 100
            local SliderPrecision = SliderConfig.Precision or 0
            local SliderIcon = SliderConfig.Icon
            local Menu = SliderConfig.Menu or {}

            if SliderMin > SliderMax then
                local ValueBefore = SliderMin
                SliderMin, SliderMax = SliderMax, ValueBefore
            end

            local SliderDef = math.clamp(SliderConfig.Def or SliderConfig.Default or 50, SliderMin, SliderMax)
            local DefaultScale = (SliderDef - SliderMin) / (SliderMax - SliderMin)

            local Slider = Objects.new("Round")
            Slider.Name = "Slider"
            Slider.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,35)
            Slider.ImageColor3 = ThisTheme.Slider
            Slider.ImageTransparency = 1
            Slider.Parent = PageContentFrame

            local SliderShadow = Objects.new("Shadow")
            SliderShadow.ImageColor3 = ThisTheme.Slider
            SliderShadow.ImageTransparency = 1
            SliderShadow.Parent = Slider

            local SliderTitle = Objects.new("Label")
            SliderTitle.TextColor3 = ThisTheme.SliderAccent
            SliderTitle.Text = SliderText
            SliderTitle.TextSize = 14
            SliderTitle.Font = Enum.Font.GothamSemibold
            SliderTitle.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-5,25)
            SliderTitle.TextTransparency = 1
            SliderTitle.Parent = Slider
            
            -- Add icon if specified
            if SliderIcon then
                local IconImg = Objects.new("Image")
                IconImg.Name = "Icon"
                IconImg.Size = UDim2.fromOffset(18, 18)
                IconImg.Position = UDim2.fromOffset(5, 3)
                IconImg.ImageColor3 = ThisTheme.SliderAccent
                IconImg.ImageTransparency = 1
                IconImg.Parent = Slider
                
                if Icons[SliderIcon] then
                    IconImg.Image = Icons[SliderIcon]
                else
                    IconImg.Image = SliderIcon
                end
                
                SliderTitle.Position = UDim2.fromOffset(28, 0)
                SliderTitle.Size = UDim2.fromScale(1, 0) + UDim2.fromOffset(-33, 25)
                
                TweenService:Create(IconImg, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            end

            local SliderValue = Objects.new("Label")
            SliderValue.Text = tostring(SliderDef)
            SliderValue.TextColor3 = ThisTheme.SliderAccent
            SliderValue.TextTransparency = 1
            SliderValue.TextSize = 14
            SliderValue.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-5,25)
            SliderValue.Position = UDim2.fromScale(0,0)
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Font = Enum.Font.GothamSemibold
            SliderValue.Parent = Slider

            local SliderTracker = Objects.new("Frame")
            SliderTracker.BackgroundColor3 = ThisTheme.SliderAccent
            SliderTracker.BackgroundTransparency = 1
            SliderTracker.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(-20,3)
            SliderTracker.Position = UDim2.fromScale(0,1) + UDim2.fromOffset(10,-10)
            SliderTracker.Parent = Slider

            local SliderFill = SliderTracker:Clone()
            SliderFill.BackgroundTransparency = 1
            SliderFill.Position = UDim2.fromScale(0,0)
            SliderFill.Size = UDim2.fromScale(DefaultScale,1)
            SliderFill.Parent = SliderTracker

            local MinSize = 10
            local MaxSize = 36

            local SizeFromScale = (MinSize + (MaxSize - MinSize)) * DefaultScale
            SizeFromScale = SizeFromScale - (SizeFromScale % 2)

            local SliderDot = Objects.new("CircleButton")
            SliderDot.Size = UDim2.fromOffset(10,10)
            SliderDot.Position = UDim2.fromScale(DefaultScale,0.5) - UDim2.fromOffset(5,5)
            SliderDot.ImageColor3 = ThisTheme.SliderAccent
            SliderDot.ImageTransparency = 1
            SliderDot.ZIndex = 50
            SliderDot.Parent = SliderTracker

            local SliderFadedDot = Objects.new("Circle")
            SliderFadedDot.Size = UDim2.fromOffset(SizeFromScale,SizeFromScale)
            SliderFadedDot.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(SizeFromScale/2,SizeFromScale/2)
            SliderFadedDot.ImageColor3 = ThisTheme.SliderAccent
            SliderFadedDot.ImageTransparency = 1
            SliderFadedDot.ZIndex = 50
            SliderFadedDot.Parent = SliderDot

            TweenService:Create(Slider, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            TweenService:Create(SliderShadow, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            TweenService:Create(SliderTitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            TweenService:Create(SliderValue, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            TweenService:Create(SliderTracker, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
            TweenService:Create(SliderFill, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
            TweenService:Create(SliderDot, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()

            SliderDot.MouseButton1Down:Connect(function()
                TweenService:Create(SliderFadedDot, TweenInfo.new(0.15), {ImageTransparency = 0.8}):Play()
                local MouseMove, MouseKill
                MouseMove = Mouse.Move:Connect(function()
                    local Px = GetXY(SliderTracker)
                    local NewSizeFromScale = (MinSize + (MaxSize - MinSize)) * Px
                    local Power = 10 ^ SliderPrecision
                    local Value = math.floor((SliderMin + ((SliderMax - SliderMin) * Px)) * Power) / Power
                    NewSizeFromScale = NewSizeFromScale - (NewSizeFromScale % 2)
                    TweenService:Create(SliderDot, TweenInfo.new(0.15), {Position = UDim2.fromScale(Px,0.5) - UDim2.fromOffset(5,5)}):Play()
                    TweenService:Create(SliderFill, TweenInfo.new(0.15), {Size = UDim2.fromScale(Px, 1)}):Play()
                    SliderFadedDot.Size = UDim2.fromOffset(NewSizeFromScale,NewSizeFromScale)
                    SliderFadedDot.Position = UDim2.fromScale(0.5,0.5) - UDim2.fromOffset(NewSizeFromScale/2,NewSizeFromScale/2)
                    SliderValue.Text = tostring(Value)
                    SliderCallback(Value)
                end)
                MouseKill = InputService.InputEnded:Connect(function(UserInput)
                    if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then
                        TweenService:Create(SliderFadedDot, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
                        MouseMove:Disconnect()
                        MouseKill:Disconnect()
                    end
                end)
            end)

            local MenuAdded, MenuButton = TryAddMenu(Slider, Menu, {})

            if MenuAdded then
                SliderValue.Position = SliderValue.Position - UDim2.fromOffset(25,0)
                SliderTracker.Size = SliderTracker.Size - UDim2.fromOffset(20,0)
                MenuButton.ImageColor3 = ThisTheme.SliderAccent
            end

            local SliderLibrary = {}

            function SliderLibrary:SetText(Value)
                SliderTitle.Text = Value
            end

            function SliderLibrary:GetText()
                return SliderTitle.Text
            end

            function SliderLibrary:GetValue()
                return tonumber(SliderValue.Text)
            end
            
            function SliderLibrary:SetValue(Value)
                Value = math.clamp(Value, SliderMin, SliderMax)
                local Px = (Value - SliderMin) / (SliderMax - SliderMin)
                TweenService:Create(SliderDot, TweenInfo.new(0.15), {Position = UDim2.fromScale(Px,0.5) - UDim2.fromOffset(5,5)}):Play()
                TweenService:Create(SliderFill, TweenInfo.new(0.15), {Size = UDim2.fromScale(Px, 1)}):Play()
                SliderValue.Text = tostring(Value)
                SliderCallback(Value)
            end

            function SliderLibrary:SetMin(Value)
                SliderMin = Value
            end

            function SliderLibrary:SetMax(Value)
                SliderMax = Value
            end

            function SliderLibrary:GetMin()
                return SliderMin
            end

            function SliderLibrary:GetMax()
                return SliderMax
            end

            return SliderLibrary
        end

        function OptionLibrary.TextField(TextFieldConfig)
            local TextFieldText = TextFieldConfig.Text or "nil text field"
            local TextFieldInputType = TextFieldConfig.Type or TextFieldConfig.type or "Default"
            local TextFieldCallback = TextFieldConfig.Callback or function() print("nil text field") end
            local TextFieldIcon = TextFieldConfig.Icon
            local TextFieldDefault = TextFieldConfig.Default or ""
            local Menu = TextFieldConfig.Menu or {}

            local TextField = Objects.new("Round")
            TextField.Name = "TextField"
            TextField.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,30)
            TextField.ImageColor3 = ThisTheme.TextField
            TextField.ImageTransparency = 1
            TextField.Parent = PageContentFrame

            local TextEffect = Objects.new("Frame")
            TextEffect.Name = "Effect"
            TextEffect.BackgroundTransparency = 1
            TextEffect.BackgroundColor3 = ThisTheme.TextField
            TextEffect.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,2)
            TextEffect.Position = UDim2.fromScale(0,1) - UDim2.fromOffset(0,2)
            TextEffect.Parent = TextField

            local TextShadow = Objects.new("Shadow")
            TextShadow.ImageColor3 = ThisTheme.TextField
            TextShadow.ImageTransparency = 1
            TextShadow.Parent = TextField

            local TextInput = Objects.new("Box")
            TextInput.Name = "Value"
            TextInput.PlaceholderText = TextFieldText
            TextInput.PlaceholderColor3 = ThisTheme.TextFieldAccent
            TextInput.TextInputType = Enum.TextInputType[TextFieldInputType]
            TextInput.TextColor3 = ThisTheme.TextFieldAccent
            TextInput.Text = TextFieldDefault
            TextInput.Font = Enum.Font.GothamSemibold
            TextInput.TextSize = 14
            TextInput.TextTransparency = 1
            TextInput.Parent = TextField
            
            -- Add icon if specified
            if TextFieldIcon then
                local IconImg = Objects.new("Image")
                IconImg.Name = "Icon"
                IconImg.Size = UDim2.fromOffset(18, 18)
                IconImg.Position = UDim2.fromOffset(5, 6)
                IconImg.ImageColor3 = ThisTheme.TextFieldAccent
                IconImg.ImageTransparency = 1
                IconImg.Parent = TextField
                
                if Icons[TextFieldIcon] then
                    IconImg.Image = Icons[TextFieldIcon]
                else
                    IconImg.Image = TextFieldIcon
                end
                
                TextInput.Position = UDim2.fromOffset(28, 0)
                TextInput.Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(33, 0)
                
                TweenService:Create(IconImg, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
            end

            TweenService:Create(TextField, TweenInfo.new(0.5), {ImageTransparency = 0.8}):Play()
            TweenService:Create(TextEffect, TweenInfo.new(0.5), {BackgroundTransparency = 0.2}):Play()
            TweenService:Create(TextShadow, TweenInfo.new(0.5), {ImageTransparency = 0.7}):Play()
            TweenService:Create(TextInput, TweenInfo.new(0.5), {TextTransparency = 0.5}):Play()

            TextInput.Focused:Connect(function()
                TweenService:Create(TextField, TweenInfo.new(0.5), {ImageTransparency = 0.7}):Play()
                TweenService:Create(TextInput, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
            end)

            TextInput.FocusLost:Connect(function()
                TweenService:Create(TextField, TweenInfo.new(0.5), {ImageTransparency = 0.8}):Play()
                TweenService:Create(TextInput, TweenInfo.new(0.5), {TextTransparency = 0.5}):Play()
                TextFieldCallback(TextInput.Text)
            end)

            local MenuAdded, MenuBar = TryAddMenu(TextField, Menu, {
                SetText = function(Value)
                    TextInput.Text = Value
                    TextFieldCallback(TextInput.Text)
                end
            })

            if MenuAdded then
                MenuBar.ImageColor3 = ThisTheme.TextFieldAccent
            end

            local TextFieldLibrary = {}

            function TextFieldLibrary:SetText(Value)
                TextInput.Text = Value
            end

            function TextFieldLibrary:GetText()
                return TextInput.Text
            end
            
            function TextFieldLibrary:Focus()
                TextInput:CaptureFocus()
            end

            return TextFieldLibrary
        end

        function OptionLibrary.Label(LabelConfig)
            local LabelText = LabelConfig.Text or "nil label"
            local LabelIcon = LabelConfig.Icon

            local LabelContainer = Objects.new("Round")
            LabelContainer.Name = "Label"
            LabelContainer.Size = UDim2.fromScale(1,0) + UDim2.fromOffset(0,20)
            LabelContainer.ImageColor3 = ThisTheme.MainFrame
            LabelContainer.Parent = PageContentFrame

            local LabelContent = Objects.new("Label")
            LabelContent.TextColor3 = ThisTheme.ChipSet
            LabelContent.Text = LabelText:upper()
            LabelContent.TextSize = 12
            LabelContent.Font = Enum.Font.GothamSemibold
            LabelContent.Size = UDim2.fromScale(1,1) + UDim2.fromOffset(-5,0)
            LabelContent.Position = UDim2.fromOffset(5,0)
            LabelContent.Parent = LabelContainer
            
            -- Add icon if specified
            if LabelIcon then
                local IconImg = Objects.new("Image")
                IconImg.Name = "Icon"
                IconImg.Size = UDim2.fromOffset(16, 16)
                IconImg.Position = UDim2.fromOffset(5, 2)
                IconImg.ImageColor3 = ThisTheme.ChipSet
                IconImg.Parent = LabelContainer
                
                if Icons[LabelIcon] then
                    IconImg.Image = Icons[LabelIcon]
                else
                    IconImg.Image = LabelIcon
                end
                
                LabelContent.Position = UDim2.fromOffset(26, 0)
                LabelContent.Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(-31, 0)
            end

            local LabelOptions = {}

            function LabelOptions:SetText(Text)
                LabelContent.Text = Text:upper()
            end
            
            function LabelOptions:SetIcon(IconName)
                local IconImg = LabelContainer:FindFirstChild("Icon")
                if IconImg then
                    if Icons[IconName] then
                        IconImg.Image = Icons[IconName]
                    else
                        IconImg.Image = IconName
                    end
                end
            end

            return LabelOptions
        end

        return OptionLibrary
    end
    
    -- ═══════════════════════════════════════════════════════════════
    -- UTILITY METHODS
    -- ═══════════════════════════════════════════════════════════════
    
    function TabLibrary.Destroy()
        if NewInstance then
            NewInstance:Destroy()
        end
    end
    
    function TabLibrary.Hide()
        MainFrame.Visible = false
    end
    
    function TabLibrary.Show()
        MainFrame.Visible = true
    end
    
    function TabLibrary.Toggle()
        MainFrame.Visible = not MainFrame.Visible
    end
    
    function TabLibrary.SetTitle(NewTitle)
        TitleText.Text = NewTitle
    end
    
    function TabLibrary.GetTheme()
        return ThisTheme
    end

    return TabLibrary
end

return Material
